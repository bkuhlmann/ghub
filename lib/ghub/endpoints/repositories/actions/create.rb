# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository create action.
        class Create
          include Import[
            :client,
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
                   to(client, :post),
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
