# frozen_string_literal: true

module Ghub
  module Models
    # Defines a license.
    License = Struct.new(
      :key,
      :name,
      :node_id,
      :spdx_id,
      :url
    ) do
      def initialize(**)
        super
        freeze
      end
    end
  end
end
