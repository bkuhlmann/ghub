# frozen_string_literal: true

require "containable"

module Ghub
  module Endpoints
    module Branches
      module Signature
        # Defines branch signature dependencies.
        module Container
          extend Containable

          namespace :responses do
            register :show, Ghub::Responses::BooleanLink
          end

          namespace :models do
            register :show, Ghub::Models::BooleanLink
          end
        end
      end
    end
  end
end
