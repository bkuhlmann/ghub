# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Pulls
      module Actions
        # Handles a repository index action.
        class Index
          include Pulls::Import[:client, response: "responses.index", model: "models.show"]
          include Pipeable

          def call owner, repository, **parameters
            pipe(
              client.get("repos/#{owner}/#{repository}/pulls", **parameters),
              try(:parse, catch: JSON::ParserError),
              fmap { |body| {body:} },
              validate(response),
              as(:fetch, :body),
              map { |item| model.for(**item) }
            )
          end
        end
      end
    end
  end
end
