# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Pulls
      module Actions
        # Handles a repository index action.
        class Show
          include Pulls::Import[:client, response: "responses.show", model: "models.show"]
          include Transactable

          def call owner, repository, id, **parameters
            pipe(
              client.get("repos/#{owner}/#{repository}/pulls/#{id}", **parameters),
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
