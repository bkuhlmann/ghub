# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository patch action.
        class Patch
          include Import[
            :api,
            :path,
            request: "requests.patch",
            response: "responses.show",
            model: "models.show"
          ]

          include Pipeable

          def call owner, id, body, **parameters
            path.patch(owner, id).bind do |url_path|
              pipe body,
                   validate(request),
                   insert(url_path, at: 0),
                   insert(parameters),
                   to(api, :patch),
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
