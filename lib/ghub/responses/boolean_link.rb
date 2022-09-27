# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a boolean link.
    BooleanLink = Dry::Schema.Params do
      required(:enabled).filled :bool
      required(:url).filled :string
    end
  end
end
