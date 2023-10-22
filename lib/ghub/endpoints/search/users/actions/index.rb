# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Search
      module Users
        module Actions
          # Handles a user index action.
          class Index
            include Import[:client, response: "responses.index", model: "models.index"]
            include Transactable

            def call **parameters
              pipe(
                client.get("search/users", **parameters),
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
