# frozen_string_literal: true

module Ghub
  module Models
    # Defines a team.
    Team = Struct.new(
      :description,
      :html_url,
      :id,
      :members_url,
      :name,
      :node_id,
      :parent,
      :permission,
      :privacy,
      :repositories_url,
      :slug,
      :url,
      keyword_init: true
    ) do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
