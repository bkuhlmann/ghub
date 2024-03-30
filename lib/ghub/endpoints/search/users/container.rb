# frozen_string_literal: true

require "containable"

module Ghub
  module Endpoints
    module Search
      module Users
        # Defines user dependencies.
        module Container
          extend Containable

          namespace :responses do
            register :index, Responses::Index
          end

          namespace :models do
            register :index, Models::Index
          end

          namespace :actions do
            register(:index) { Actions::Index.new }
          end
        end
      end
    end
  end
end
