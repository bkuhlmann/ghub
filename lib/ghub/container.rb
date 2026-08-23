# frozen_string_literal: true

require "containable"
require "http"
require "rfc/web/link"

module Ghub
  # Defines application dependencies.
  module Container
    extend Containable

    register(:configuration) { Configuration::Loader.new.call }
    register :http, HTTP
    register(:api) { API::Client.new }
    register(:web_link) { RFC::Web::Link.new self[:configuration].url }
  end
end
