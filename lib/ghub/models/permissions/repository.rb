# frozen_string_literal: true

module Ghub
  module Models
    module Permissions
      # Defines repository permissions.
      Repository = Struct.new(
        :admin,
        :maintain,
        :pull,
        :push,
        :triage
      ) do
        def initialize(**)
          super
          freeze
        end
      end
    end
  end
end
