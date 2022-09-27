# frozen_string_literal: true

module Ghub
  module Models
    module Permissions
      # Defines branch permissions.
      Branch = Struct.new(
        :contents,
        :issues,
        :metadata,
        :single_file,
        keyword_init: true
      ) do
        def initialize *arguments
          super
          freeze
        end
      end
    end
  end
end
