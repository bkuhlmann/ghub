# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Actions
          # Handles a branch projection show action.
          class Show
            include Ghub::Import[:api]
            include Protection::Import[response: "responses.show", model: "models.show"]
            include Pipeable

            def call owner, repository, branch, **parameters
              pipe(
                api.get(
                  "repos/#{owner}/#{repository}/branches/#{branch}/protection",
                  **parameters
                ),
                try(:parse, catch: JSON::ParserError),
                validate(response, as: :to_h),
                to(model, :for)
              )
            end
          end
        end
      end
    end
  end
end
