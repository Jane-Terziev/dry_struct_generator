# frozen_string_literal: true

require "dry_struct_generator/types"

module DryStructGenerator
  module Config
    module GeneratorConfiguration
      extend Configuration

      define_setting :struct_class, Dry::Struct
      define_setting :validation_schema_parser, ::DryValidationParser::ValidationSchemaParser
      define_setting :type_to_dry_type, {
        'array': Types::Array,
        'boolean': Types::Bool,
        'date': Types::Date,
        'datetime': Types::DateTime,
        'float': Types::Float,
        'integer': Types::Integer,
        'string': Types::String,
        'time': Types::Time
      }.freeze
    end
  end
end
