# frozen_string_literal: true

require "dry/monads"
require "dry/schema"
require "zeitwerk"

Dry::Schema.load_extensions :monads

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "api" => "API"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Ghub
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
