# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a user.
    User = Dry::Schema.Params do
      required(:avatar_url).filled(:string)
      required(:events_url).filled(:string)
      required(:followers_url).filled(:string)
      required(:following_url).filled(:string)
      required(:gists_url).filled(:string)
      required(:gravatar_id).maybe(:string)
      required(:html_url).filled(:string)
      required(:id).filled(:integer)
      required(:login).filled(:string)
      required(:node_id).filled(:string)
      required(:organizations_url).filled(:string)
      required(:received_events_url).filled(:string)
      required(:repos_url).filled(:string)
      required(:site_admin).filled(:bool)
      required(:starred_url).filled(:string)
      required(:subscriptions_url).filled(:string)
      required(:type).filled(:string)
      required(:url).filled(:string)
    end
  end
end
