# frozen_string_literal: true

module Ghub
  module Models
    # Defines a link.
    Link = Struct.new :href, keyword_init: true do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
