# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Organizations
      module Members
        module Actions
          # Handles an organization member index action.
          class Index
            include Members::Import[:client, response: "responses.index", model: "models.show"]
            include Transactable

            def call owner, **parameters
              pipe(
                "orgs/#{owner}/members",
                insert(parameters),
                to(client, :get),
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
