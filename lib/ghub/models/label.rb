# frozen_string_literal: true

module Ghub
  module Models
    # Defines a label.
    Label = Struct.new(
      :color,
      :default,
      :description,
      :id,
      :name,
      :node_id,
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
