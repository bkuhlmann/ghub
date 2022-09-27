# frozen_string_literal: true

module Ghub
  module Models
    # Defines a check.
    Check = Struct.new(
      :context,
      :app_id,
      keyword_init: true
    ) do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
