# frozen_string_literal: true

module Ghub
  module Models
    # Defines a check.
    Check = Struct.new :context, :app_id do
      def initialize(**)
        super
        freeze
      end
    end
  end
end
