# frozen_string_literal: true

module Ghub
  module Endpoints
    module Search
      module Users
        module Responses
          # Defines a user within a collection.
          Index = Dry::Schema.Params do
            required(:total_count).filled :integer
            required(:incomplete_results).filled :bool
            required(:items).array(:hash) do
              required(:avatar_url).filled :string
              required(:events_url).filled :string
              required(:followers_url).filled :string
              required(:following_url).filled :string
              required(:gists_url).filled :string
              required(:gravatar_id).maybe :string
              required(:html_url).filled :string
              required(:id).filled :integer
              required(:login).filled :string
              required(:node_id).filled :string
              required(:organizations_url).filled :string
              required(:received_events_url).filled :string
              required(:repos_url).filled :string
              required(:score).filled :float
              required(:site_admin).filled :bool
              required(:starred_url).filled :string
              required(:subscriptions_url).filled :string
              required(:type).filled :string
              required(:url).filled :string
            end
          end
        end
      end
    end
  end
end
