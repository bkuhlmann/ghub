# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Users
      module Actions
        # Handles a user show action.
        class Show
          include Ghub::Dependencies[:api]
          include Dependencies[response: "responses.show", model: "models.show"]
          include Pipeable

          def call id, **parameters
            pipe api.get("users/#{id}", **parameters),
                 try(:parse, catch: JSON::ParserError),
                 validate(response, as: :to_h),
                 to(model, :for)
          end
        end
      end
    end
  end
end
