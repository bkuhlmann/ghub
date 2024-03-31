# frozen_string_literal: true

module Ghub
  module Endpoints
    module Users
      module Models
        # Defines a single user.
        Show = Struct.new(
          :avatar_url,
          :bio,
          :blog,
          :company,
          :created_at,
          :email,
          :events_url,
          :followers,
          :followers_url,
          :following,
          :following_url,
          :gists_url,
          :gravatar_id,
          :hireable,
          :html_url,
          :id,
          :location,
          :login,
          :name,
          :node_id,
          :organizations_url,
          :public_gists,
          :public_repos,
          :received_events_url,
          :repos_url,
          :site_admin,
          :starred_url,
          :subscriptions_url,
          :twitter_username,
          :type,
          :updated_at,
          :url
        ) do
          def self.for(**) = new(**)

          def initialize(**)
            super
            freeze
          end
        end
      end
    end
  end
end
