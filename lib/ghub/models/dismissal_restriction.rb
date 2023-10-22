# frozen_string_literal: true

module Ghub
  module Models
    # Defines a dismissal restriction.
    DismissalRestriction = Struct.new(
      :apps,
      :teams,
      :teams_url,
      :url,
      :users,
      :users_url
    ) do
      def self.for(**attributes)
        return new if attributes.empty?

        new(
          **attributes.merge!(
            apps: attributes[:apps].map { |arguments| Application[**arguments] },
            teams: attributes[:teams].map { |arguments| Team[**arguments] },
            users: attributes[:users].map { |arguments| User[**arguments] }
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
