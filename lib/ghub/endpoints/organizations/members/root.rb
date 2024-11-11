# frozen_string_literal: true

module Ghub
  module Endpoints
    module Organizations
      module Members
        # Provides access to the organization members API endpoint.
        class Root
          include Dependencies[index_action: "actions.index"]

          def index(...) = index_action.call(...)
        end
      end
    end
  end
end
