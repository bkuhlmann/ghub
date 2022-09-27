# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a permission.
    Permission = Dry::Schema.Params do
      required(:admin).filled :bool
      required(:maintain).filled :bool
      required(:pull).filled :bool
      required(:push).filled :bool
      required(:triage).filled :bool
    end
  end
end
