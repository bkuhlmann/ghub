# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a review.
    Review = Dry::Schema.Params do
      required(:dismiss_stale_reviews).filled :bool
      required(:require_code_owner_reviews).filled :bool
      required(:required_approving_review_count).filled :integer
      required(:url).filled :string

      optional(:dismissal_restrictions).hash(DismissalRestriction)
    end
  end
end
