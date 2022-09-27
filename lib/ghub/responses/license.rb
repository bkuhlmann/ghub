# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a license.
    License = Dry::Schema.Params do
      required(:key).filled :string
      required(:name).filled :string
      required(:node_id).filled :string
      required(:spdx_id).filled :string
      required(:url).maybe :string
    end
  end
end
