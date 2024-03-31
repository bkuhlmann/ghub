# frozen_string_literal: true

module Ghub
  module Endpoints
    module Branches
      module Protection
        # Provides access to the branch protection API endpoint.
        class Root
          include Protection::Import[
            :api,
            show_action: "actions.show",
            update_action: "actions.update"
          ]

          def show(...) = show_action.call(...)

          def update(...) = update_action.call(...)

          def destroy owner, repository, branch
            api.delete "repos/#{owner}/#{repository}/branches/#{branch}/protection"
          end
        end
      end
    end
  end
end
