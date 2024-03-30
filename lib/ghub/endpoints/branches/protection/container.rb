# frozen_string_literal: true

require "containable"

module Ghub
  module Endpoints
    module Branches
      module Protection
        # Defines branch protection dependencies.
        module Container
          extend Containable

          namespace :requests do
            register :update, Requests::Update
          end

          namespace :responses do
            register :show, Responses::Show
          end

          namespace :models do
            register :show, Models::Show
          end

          namespace :actions do
            register(:show) { Actions::Show.new }
            register(:update) { Actions::Update.new }
          end
        end
      end
    end
  end
end
