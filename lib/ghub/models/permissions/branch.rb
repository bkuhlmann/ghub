# frozen_string_literal: true

module Ghub
  module Models
    module Permissions
      # Defines branch permissions.
      Branch = Struct.new(
        :contents,
        :issues,
        :metadata,
        :single_file
      ) do
        def initialize(**)
          super
          freeze
        end
      end
    end
  end
end
