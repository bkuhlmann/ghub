# frozen_string_literal: true

require "containable"
require "http"

module Ghub
  # Defines application dependencies.
  module Container
    extend Containable

    register(:configuration) { Configuration::Loader.new.call }
    register :http, HTTP
    register(:api) { API::Client.new }
  end
end
