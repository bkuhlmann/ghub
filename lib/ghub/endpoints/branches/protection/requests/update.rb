# frozen_string_literal: true

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Requests
          # Defines the data structure for updating a protected branch.
          Update = Dry::Schema.JSON do
            required(:enforce_admins).filled :bool

            required(:required_pull_request_reviews).maybe(:hash) do
              optional(:bypass_pull_request_allowances).hash do
                optional(:users).array :string
                optional(:teams).array :string
                optional(:apps).array :string
              end

              optional(:dismiss_stale_reviews).filled :bool

              optional(:dismissal_restrictions).hash do
                optional(:users).array :string
                optional(:teams).array :string
                optional(:apps).array :string
              end

              optional(:require_code_owner_reviews).filled :bool
              optional(:required_approving_review_count).filled :integer
            end

            required(:required_status_checks).hash do
              required(:strict).filled :bool
              required(:contexts).array(:string)
            end

            required(:restrictions).maybe(:hash) do
              required(:users).array :string
              required(:teams).array :string
              optional(:apps).array :string
            end

            optional(:allow_deletions).filled :bool
            optional(:allow_force_pushes).filled :bool
            optional(:block_creations).filled :bool
            optional(:required_conversation_resolution).filled :bool
            optional(:required_linear_history).filled :bool
          end
        end
      end
    end
  end
end
