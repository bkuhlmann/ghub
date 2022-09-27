# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a status check.
    StatusCheck = Dry::Schema.Params do
      required(:url).filled :string
      required(:strict).filled :bool
      required(:contexts).array(:str?)
      required(:contexts_url).filled :string

      required(:checks).array(:hash) do
        required(:context).filled :string
        required(:app_id).maybe :integer
      end

      optional(:enforcement_level).filled :string
    end
  end
end
