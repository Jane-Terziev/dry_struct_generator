# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require 'dry_validation_parser'
require_relative "dry_struct_generator/version"
require_relative "dry_struct_generator/config/configuration"
require_relative "dry_struct_generator/config/generator_configuration"
require_relative 'dry_struct_generator/types'
require_relative 'dry_struct_generator/struct_generator'

module DryStructGenerator
  class Error < StandardError; end
end
