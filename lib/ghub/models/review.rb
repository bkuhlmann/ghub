# frozen_string_literal: true

module Ghub
  module Models
    # Defines a review.
    Review = Struct.new(
      :dismiss_stale_reviews,
      :require_code_owner_reviews,
      :required_approving_review_count,
      :url,
      :dismissal_restrictions,
      keyword_init: true
    ) do
      def self.for attributes
        return new unless attributes

        new attributes.merge(
          dismissal_restrictions: DismissalRestriction.for(attributes[:dismissal_restrictions])
        )
      end

      def initialize *arguments
        super
        freeze
      end
    end
  end
end
