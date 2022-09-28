# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Actions
          # Handles a branch projection show action.
          class Show
            include Protection::Import[:client, response: "responses.show", model: "models.show"]
            include Transactable

            def call owner, repository, branch, **parameters
              pipe(
                client.get(
                  "repos/#{owner}/#{repository}/branches/#{branch}/protection",
                  **parameters
                ),
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
