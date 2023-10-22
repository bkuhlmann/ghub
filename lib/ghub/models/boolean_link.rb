# frozen_string_literal: true

module Ghub
  module Models
    # Defines a boolean link.
    BooleanLink = Struct.new :enabled, :url do
      def self.for(**) = new(**)

      def initialize(**)
        super
        freeze
      end
    end
  end
end
