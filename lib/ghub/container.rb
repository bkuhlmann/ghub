# frozen_string_literal: true

require "dry-container"
require "http"

module Ghub
  # Defines application dependencies.
  module Container
    extend Dry::Container::Mixin

    register(:http) { HTTP }
  end
end
