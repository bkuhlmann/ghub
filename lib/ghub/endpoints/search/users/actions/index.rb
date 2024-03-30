# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Search
      module Users
        module Actions
          # Handles a user index action.
          class Index
            include Ghub::Import[:api]
            include Import[response: "responses.index", model: "models.index"]
            include Pipeable

            def call **parameters
              pipe(
                api.get("search/users", **parameters),
                try(:parse, catch: JSON::ParserError),
                validate(response),
                as(:fetch, :items),
                map { |item| model.for(**item) }
              )
            end
          end
        end
      end
    end
  end
end
