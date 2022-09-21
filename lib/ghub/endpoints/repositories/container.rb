# frozen_string_literal: true

require "dry/container"

module Ghub
  module Endpoints
    module Repositories
      # Defines repository dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Ghub::Container

        namespace :requests do
          register(:create) { Requests::Create }
          register(:patch) { Requests::Patch }
        end

        namespace :responses do
          register(:index) { Responses::Index }
          register(:show) { Ghub::Responses::Repository }
        end

        namespace :models do
          register(:show) { Ghub::Models::Repository }
        end

        register(:path) { Path.new }

        namespace :actions do
          register(:create) { Actions::Create.new }
          register(:index) { Actions::Index.new }
          register(:patch) { Actions::Patch.new }
          register(:show) { Actions::Show.new }
        end
      end
    end
  end
end
