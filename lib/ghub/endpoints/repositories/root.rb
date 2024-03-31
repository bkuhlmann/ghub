# frozen_string_literal: true

module Ghub
  module Endpoints
    module Repositories
      # Provides access to the users API endpoint.
      class Root
        include Repositories::Import[
          :api,
          create_action: "actions.create",
          index_action: "actions.index",
          patch_action: "actions.patch",
          show_action: "actions.show"
        ]

        def index(...) = index_action.call(...)

        def show(...) = show_action.call(...)

        def create(...) = create_action.call(...)

        def patch(...) = patch_action.call(...)

        def destroy(owner, id) = api.delete "repos/#{owner}/#{id}"
      end
    end
  end
end
