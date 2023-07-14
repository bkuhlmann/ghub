# frozen_string_literal: true

require "dry/container"

module Ghub
  module Endpoints
    module Search
      module Users
        # Defines user dependencies.
        module Container
          extend Dry::Container::Mixin

          merge Ghub::Container

          namespace :responses do
            register(:index) { Responses::Index }
          end

          namespace :models do
            register(:index) { Models::Index }
          end

          namespace :actions do
            register(:index) { Actions::Index.new }
          end
        end
      end
    end
  end
end
