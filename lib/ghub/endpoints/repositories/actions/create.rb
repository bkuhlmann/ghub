# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository create action.
        class Create
          include Ghub::Import[:api]

          include Import[
            :path,
            request: "requests.create",
            response: "responses.show",
            model: "models.show"
          ]

          include Pipeable

          def call kind, body, owner: nil, **parameters
            path.create(kind, owner:).bind do |url_path|
              pipe body,
                   validate(request),
                   insert(url_path, at: 0),
                   insert(parameters),
                   to(api, :post),
                   try(:parse, catch: JSON::ParserError),
                   validate(response),
                   to(model, :for)
            end
          end
        end
      end
    end
  end
end
