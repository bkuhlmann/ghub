# frozen_string_literal: true

module Ghub
  module Models
    # Defines a branch.
    Branch = Struct.new :label, :ref, :repo, :sha, :user do
      def self.for(**attributes)
        new(
          **attributes.merge!(
            user: User[**attributes[:user]],
            repo: Repository.for(**attributes[:repo])
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
