# frozen_string_literal: true

module Ghub
  # Allows a model to be callable, frozen, and cast itself as a monad to be processed as a result.
  module Resultable
    include Dry::Monads[:result]

    def self.included descendant
      super
      descendant.extend ClassMethods
    end

    # Allows an object to be callable via a class method.
    module ClassMethods
      def call(...) = new(...)
    end

    def to_monad = Success self
  end
end
