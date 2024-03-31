# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Actions
          # Handles a branch projection update action.
          class Update
            include Protection::Import[
              :api,
              request: "requests.update",
              response: "responses.show",
              model: "models.show"
            ]

            include Pipeable

            def call owner, repository, branch, body, **parameters
              pipe(
                body,
                validate(request),
                insert("repos/#{owner}/#{repository}/branches/#{branch}/protection", at: 0),
                insert(parameters),
                to(api, :put),
                try(:parse, catch: JSON::ParserError),
                validate(response),
                to(model, :for)
              )
            end
          end
        end
      end
    end
  end
end
