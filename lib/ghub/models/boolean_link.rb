# frozen_string_literal: true

module Ghub
  module Models
    # Defines a boolean link.
    BooleanLink = Struct.new :enabled, :url, keyword_init: true do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
