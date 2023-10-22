# frozen_string_literal: true

module Ghub
  module Models
    # Defines a review.
    Review = Struct.new(
      :dismiss_stale_reviews,
      :require_code_owner_reviews,
      :required_approving_review_count,
      :url,
      :dismissal_restrictions
    ) do
      def self.for(**attributes)
        return new if attributes.empty?

        new(
          **attributes.merge!(
            dismissal_restrictions: DismissalRestriction.for(**attributes[:dismissal_restrictions])
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
