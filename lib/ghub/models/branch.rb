# frozen_string_literal: true

module Ghub
  module Models
    # Defines a branch.
    Branch = Struct.new :label, :ref, :repo, :sha, :user, keyword_init: true do
      def self.for attributes
        new attributes.merge(
          user: User[attributes[:user]],
          repo: Repository.for(attributes[:repo])
        )
      end

      def initialize *arguments
        super
        freeze
      end
    end
  end
end
