# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Repositories
      module Actions
        # Handles a repository index action.
        class Index
          include Ghub::Dependencies[:api]
          include Dependencies[:path, response: "responses.index", model: "models.show"]
          include Pipeable

          def call kind, owner, **parameters
            pipe(
              path.index(kind, owner),
              insert(parameters),
              to(api, :get),
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
