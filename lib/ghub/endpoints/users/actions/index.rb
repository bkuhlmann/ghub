# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Users
      module Actions
        # Handles a user index action.
        class Index
          include Users::Import[:client, response: "responses.index", model: "models.index"]
          include Transactable

          def call **parameters
            pipe(
              client.get("users", **parameters),
              try(:parse, catch: JSON::ParserError),
              fmap { |body| {body:} },
              validate(response),
              as(:fetch, :body),
              map { |item| model.for(**item) }
            )
          end
        end
      end
    end
  end
end
