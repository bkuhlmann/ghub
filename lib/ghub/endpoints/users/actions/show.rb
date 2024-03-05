# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Users
      module Actions
        # Handles a user show action.
        class Show
          include Users::Import[:client, response: "responses.show", model: "models.show"]
          include Pipeable

          def call id, **parameters
            pipe client.get("users/#{id}", **parameters),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :for)
          end
        end
      end
    end
  end
end
