# frozen_string_literal: true

module Ghub
  module Endpoints
    module Users
      # Provides access to the users API endpoint.
      class Root
        include Users::Import[index_action: "actions.index", show_action: "actions.show"]

        def index(...) = index_action.call(...)

        def show(...) = show_action.call(...)
      end
    end
  end
end
