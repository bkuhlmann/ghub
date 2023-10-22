# frozen_string_literal: true

module Ghub
  module Models
    # Defines a status check.
    StatusCheck = Struct.new(
      :url,
      :strict,
      :contexts,
      :contexts_url,
      :checks,
      :enforcement_level
    ) do
      def self.for(**attributes)
        new(
          **attributes.merge!(checks: attributes[:checks].map { |arguments| Check[**arguments] })
        )
      end

      def initialize(**)
        super
        freeze
      end
    end
  end
end
