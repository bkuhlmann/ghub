# frozen_string_literal: true

require "refinements/string"

module Ghub
  module Configuration
    # Handles loading of configuration with environment defaults.
    class Loader
      using Refinements::String

      def initialize model = Content, environment: ENV
        @model = model
        @environment = environment
      end

      def call
        model[
          accept: environment.fetch("GITHUB_API_ACCEPT", "application/vnd.github+json"),
          paginate: environment.fetch("GITHUB_API_PAGINATE", "false").to_bool,
          token: environment["GITHUB_API_TOKEN"],
          url: environment.fetch("GITHUB_API_URL", "https://api.github.com")
        ]
      end

      private

      attr_reader :model, :environment
    end
  end
end
