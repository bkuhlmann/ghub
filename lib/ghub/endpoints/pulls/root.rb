# frozen_string_literal: true

module Ghub
  module Endpoints
    module Pulls
      # Provides access to the pulls API endpoint.
      class Root
        include Dependencies[index_action: "actions.index", show_action: "actions.show"]

        def index(...) = index_action.call(...)

        def show(...) = show_action.call(...)
      end
    end
  end
end
