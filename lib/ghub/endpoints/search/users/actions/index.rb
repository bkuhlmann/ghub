# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Search
      module Users
        module Actions
          # Handles a user index action.
          class Index
            include Ghub::Dependencies[:api]
            include Dependencies[response: "responses.index", model: "models.index"]
            include Pipeable

            def call **parameters
              pipe(
                api.get("search/users", **parameters),
                try(:parse, catch: JSON::ParserError),
                validate(response, as: :to_h),
                as(:fetch, :items),
                map { |item| model.for(**item) }
              )
            end
          end
        end
      end
    end
  end
end
