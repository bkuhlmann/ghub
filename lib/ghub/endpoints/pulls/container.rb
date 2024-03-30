# frozen_string_literal: true

require "containable"

module Ghub
  module Endpoints
    module Pulls
      # Defines pull request dependencies.
      module Container
        extend Containable

        namespace :responses do
          register :index, Responses::Index
          register :show, Responses::Show
        end

        namespace :models do
          register :show, Models::Show
        end

        namespace :actions do
          register(:index) { Actions::Index.new }
          register(:show) { Actions::Show.new }
        end
      end
    end
  end
end
