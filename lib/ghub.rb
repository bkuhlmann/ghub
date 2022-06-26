# frozen_string_literal: true

require "dry/monads"
require "dry/schema"
require "zeitwerk"

Dry::Schema.load_extensions :monads

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "api" => "API"
  loader.setup
end

# Main namespace.
module Ghub
end
