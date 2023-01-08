# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository patch action.
        class Patch
          include Import[
            :client,
            :path,
            request: "requests.patch",
            response: "responses.show",
            model: "models.show"
          ]

          include Transactable

          def call owner, id, body, **parameters
            path.patch(owner, id).bind do |url_path|
              pipe body,
                   validate(request),
                   insert(url_path, at: 0),
                   insert(parameters),
                   to(client, :patch),
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
