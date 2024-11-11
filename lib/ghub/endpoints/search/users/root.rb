# frozen_string_literal: true

module Ghub
  module Endpoints
    module Search
      module Users
        # Provides access to the search API endpoint for users.
        class Root
          include Dependencies[index_action: "actions.index"]

          def index(...) = index_action.call(...)
        end
      end
    end
  end
end
