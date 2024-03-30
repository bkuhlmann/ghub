# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Pulls
      module Actions
        # Handles a repository index action.
        class Show
          include Ghub::Import[:api]
          include Pulls::Import[response: "responses.show", model: "models.show"]
          include Pipeable

          def call owner, repository, id, **parameters
            pipe(
              api.get("repos/#{owner}/#{repository}/pulls/#{id}", **parameters),
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
