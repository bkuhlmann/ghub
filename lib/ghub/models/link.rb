# frozen_string_literal: true

module Ghub
  module Models
    # Defines a link.
    Link = Struct.new :href do
      def initialize(**)
        super
        freeze
      end
    end
  end
end
