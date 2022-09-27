# frozen_string_literal: true

require "dry/container"

module Ghub
  module Endpoints
    module Pulls
      # Defines pull request dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Ghub::Container

        namespace :responses do
          register(:index) { Responses::Index }
          register(:show) { Responses::Show }
        end

        namespace :models do
          register(:show) { Models::Show }
        end

        namespace :actions do
          register(:index) { Actions::Index.new }
          register(:show) { Actions::Show.new }
        end
      end
    end
  end
end
