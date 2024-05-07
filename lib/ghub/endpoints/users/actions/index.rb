# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Users
      module Actions
        # Handles a user index action.
        class Index
          include Ghub::Import[:api]
          include Users::Import[response: "responses.index", model: "models.index"]
          include Pipeable

          def call **parameters
            pipe(
              api.get("users", **parameters),
              try(:parse, catch: JSON::ParserError),
              fmap { |body| {body:} },
              validate(response, as: :to_h),
              as(:fetch, :body),
              map { |item| model.for(**item) }
            )
          end
        end
      end
    end
  end
end
