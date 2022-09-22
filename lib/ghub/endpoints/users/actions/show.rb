# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Users
      module Actions
        # Handles a user show action.
        class Show
          include Users::Import[:client, response: "responses.show", model: "models.show"]
          include Transactable

          def call id, **parameters
            pipe client.get("users/#{id}", **parameters),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :new)
          end
        end
      end
    end
  end
end
