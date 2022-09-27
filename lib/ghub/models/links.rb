# frozen_string_literal: true

module Ghub
  module Models
    # Defines a set of links.
    Links = Struct.new(
      :self,
      :html,
      :issue,
      :comments,
      :review_comments,
      :review_comment,
      :commits,
      :statuses,
      keyword_init: true
    ) do
      def self.for attributes
        attributes.reduce({}) { |collection, (key, value)| collection.merge key => Link[value] }
                  .then { |updated_attributes| new updated_attributes }
      end

      def initialize *arguments
        super
        freeze
      end
    end
  end
end
