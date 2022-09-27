# frozen_string_literal: true

module Ghub
  module Models
    # Defines an owner.
    Owner = Struct.new(
      :login,
      :id,
      :node_id,
      :url,
      :repos_url,
      :events_url,
      :hooks_url,
      :issues_url,
      :members_url,
      :public_members_url,
      :avatar_url,
      :description,
      keyword_init: true
    ) do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
