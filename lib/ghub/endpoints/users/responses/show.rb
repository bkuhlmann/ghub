# frozen_string_literal: true

module Ghub
  module Endpoints
    module Users
      module Responses
        # Defines a single user.
        Show = Dry::Schema.JSON do
          required(:avatar_url).filled :string
          required(:bio).maybe :string
          required(:blog).maybe :string
          required(:company).maybe :string
          required(:created_at).filled :date_time
          required(:email).maybe :string
          required(:events_url).filled :string
          required(:followers).filled :integer
          required(:followers_url).filled :string
          required(:following).filled :integer
          required(:following_url).filled :string
          required(:gists_url).filled :string
          required(:gravatar_id).maybe :string
          required(:hireable).maybe :string
          required(:html_url).filled :string
          required(:id).filled :integer
          required(:location).maybe :string
          required(:login).filled :string
          required(:name).maybe :string
          required(:node_id).filled :string
          required(:organizations_url).filled :string
          required(:public_gists).filled :integer
          required(:public_repos).filled :integer
          required(:received_events_url).filled :string
          required(:repos_url).filled :string
          required(:site_admin).filled :bool
          required(:starred_url).filled :string
          required(:subscriptions_url).filled :string
          required(:twitter_username).maybe :string
          required(:type).filled :string
          required(:updated_at).filled :date_time
          required(:url).filled :string
        end
      end
    end
  end
end
