# frozen_string_literal: true

require "dry-container"
require "http"

module Ghub
  # Defines application dependencies.
  module Container
    extend Dry::Container::Mixin

    register(:configuration, memoize: true) { Configuration::Loader.new.call }
    register(:http) { HTTP }
    register(:client) { API::Client.new }
  end
end
