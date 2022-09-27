# frozen_string_literal: true

module Ghub
  module Models
    # Defines a license.
    License = Struct.new(
      :key,
      :name,
      :node_id,
      :spdx_id,
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
