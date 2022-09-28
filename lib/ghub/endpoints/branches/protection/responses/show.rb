# frozen_string_literal: true

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Responses
          # Defines a brnach protection response.
          Show = Dry::Schema.Params do
            required(:allow_deletions).hash { required(:enabled).filled :bool }
            required(:allow_force_pushes).hash { required(:enabled).filled :bool }
            required(:block_creations).hash { required(:enabled).filled :bool }
            required(:enforce_admins).hash(Ghub::Responses::BooleanLink)
            required(:required_conversation_resolution).hash { required(:enabled).filled :bool }
            required(:required_linear_history).hash { required(:enabled).filled :bool }
            required(:required_signatures).hash(Ghub::Responses::BooleanLink)
            required(:required_status_checks).hash(Ghub::Responses::StatusCheck)
            required(:url).filled :string

            optional(:required_pull_request_reviews).hash(Ghub::Responses::Review)
            optional(:restrictions).hash(Ghub::Responses::Restriction)
          end
        end
      end
    end
  end
end
