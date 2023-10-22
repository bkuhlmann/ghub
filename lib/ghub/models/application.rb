# frozen_string_literal: true

module Ghub
  module Models
    # Defines an application.
    Application = Struct.new(
      :created_at,
      :description,
      :events,
      :external_url,
      :html_url,
      :id,
      :name,
      :node_id,
      :owner,
      :permissions,
      :slug,
      :updated_at
    ) do
      def self.for(**attributes)
        new(
          **attributes.merge!(
            owner: Owner[**attributes[:owner]],
            permissions: Permissions::Branch[**attributes[:permissions]]
          )
        )
      end

      def initialize(**)
        super
        freeze
      end
    end
  end
end
