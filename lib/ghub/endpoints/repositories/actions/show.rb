# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository show action.
        class Show
          include Repositories::Import[
            :client,
            :path,
            response: "responses.show",
            model: "models.show"
          ]

          include Pipeable

          def call owner, id, **parameters
            pipe path.show(owner, id),
                 insert(parameters),
                 to(client, :get),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :for)
          end
        end
      end
    end
  end
end
