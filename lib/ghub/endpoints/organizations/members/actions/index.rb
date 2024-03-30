# frozen_string_literal: true

require "pipeable"

module Ghub
  module Endpoints
    module Organizations
      module Members
        module Actions
          # Handles an organization member index action.
          class Index
            include Ghub::Import[:api]
            include Members::Import[response: "responses.index", model: "models.show"]
            include Pipeable

            def call owner, **parameters
              pipe(
                "orgs/#{owner}/members",
                insert(parameters),
                to(api, :get),
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
end
