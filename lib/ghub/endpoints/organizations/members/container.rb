# frozen_string_literal: true

require "dry/container"

module Ghub
  module Endpoints
    module Organizations
      module Members
        # Defines member dependencies.
        module Container
          extend Dry::Container::Mixin

          merge Ghub::Container

          namespace :responses do
            register(:index) { Responses::Index }
          end

          namespace :models do
            register(:show) { Ghub::Models::User }
          end

          namespace :actions do
            register(:index) { Actions::Index.new }
          end
        end
      end
    end
  end
end
