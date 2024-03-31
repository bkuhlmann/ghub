# frozen_string_literal: true

module Ghub
  module Endpoints
    module Branches
      module Protection
        module Models
          # Defines branch protection.
          Show = Struct.new(
            :allow_deletions,
            :allow_force_pushes,
            :block_creations,
            :enforce_admins,
            :required_conversation_resolution,
            :required_linear_history,
            :required_pull_request_reviews,
            :required_signatures,
            :required_status_checks,
            :restrictions,
            :url
          ) do
            def self.for(**attributes)
              new(
                **attributes.merge!(
                  enforce_admins: Ghub::Models::BooleanLink[**attributes[:enforce_admins]],
                  required_signatures: Ghub::Models::BooleanLink[
                    **Hash(attributes[:required_signatures])
                  ],
                  required_status_checks: Ghub::Models::StatusCheck.for(
                    **Hash(attributes[:required_status_checks])
                  ),
                  required_pull_request_reviews: Ghub::Models::Review.for(
                    **Hash(attributes[:required_pull_request_reviews])
                  ),
                  restrictions: Ghub::Models::Restriction.for(**Hash(attributes[:restrictions]))
                )
              )
            end

            def initialize(**)
              super
              freeze
            end
          end
        end
      end
    end
  end
end
