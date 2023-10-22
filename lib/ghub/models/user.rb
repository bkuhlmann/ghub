# frozen_string_literal: true

module Ghub
  module Models
    # Defines a user.
    User = Struct.new(
      :avatar_url,
      :events_url,
      :followers_url,
      :following_url,
      :gists_url,
      :gravatar_id,
      :html_url,
      :id,
      :login,
      :node_id,
      :organizations_url,
      :received_events_url,
      :repos_url,
      :site_admin,
      :starred_url,
      :subscriptions_url,
      :type,
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
