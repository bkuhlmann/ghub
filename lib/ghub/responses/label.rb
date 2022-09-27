# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a label.
    Label = Dry::Schema.Params do
      required(:color).filled :string
      required(:default).filled :bool
      required(:description).maybe :string
      required(:id).filled :integer
      required(:name).filled :string
      required(:node_id).filled :string
      required(:url).filled :string
    end
  end
end
