# frozen_string_literal: true

module DryStructGenerator
  class StructGenerator
    @@definitions = {}

    attr_accessor :struct_class, :type_to_dry_type, :validation_schema_parser

    def initialize(
      struct_class: Config::GeneratorConfiguration.struct_class,
      validation_schema_parser: Config::GeneratorConfiguration.validation_schema_parser,
      type_to_dry_type: Config::GeneratorConfiguration.type_to_dry_type
    )
      self.struct_class = struct_class
      self.type_to_dry_type = type_to_dry_type
      self.validation_schema_parser = validation_schema_parser
    end

    def self.definitions
      @@definitions
    end

    def call(validator, options = {})
      return @@definitions[validator] if @@definitions[validator]

      validator_definition = validation_schema_parser.new.call(validator).keys.merge(options)
      result = generate(validator_definition)

      @@definitions[validator] = result

      result
    end

    def generate(validator_definition)
      instance = self
      Class.new(struct_class) do
        validator_definition.each do |field_name, schema|
          type = instance.get_field_type(schema)
          schema[:required] ? attribute(field_name.to_sym, type) : attribute?(field_name.to_sym, type)
        end
      end
    end

    def get_field_type(schema)
      if schema[:array]
        type = type_to_dry_type[:array]
        type = schema[:keys] ? type.of(generate(schema[:keys].to_sym)) : type.of(type_to_dry_type[schema[:type].to_sym])
      elsif schema[:keys]
        type = generate(schema[:keys])
      else
        type = type_to_dry_type[schema[:type].to_sym]
        type = type.optional if schema[:nullable]
        type = type.default(schema[:default]) if schema[:default]
      end

      type
    end
  end
end
