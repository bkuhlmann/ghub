# frozen_string_literal: true

module Ghub
  module Endpoints
    module Repositories
      module Requests
        # Defines the data structure for creating a repository.
        Create = Dry::Schema.JSON do
          required(:name).filled :string

          optional(:allow_auto_merge).filled :bool
          optional(:allow_merge_commit).filled :bool
          optional(:allow_rebase_merge).filled :bool
          optional(:allow_squash_merge).filled :bool
          optional(:auto_init).filled :bool
          optional(:delete_branch_on_merge).filled :bool
          optional(:description).filled :string
          optional(:gitignore_template).filled :string
          optional(:has_downloads).filled :bool
          optional(:has_issues).filled :bool
          optional(:has_projects).filled :bool
          optional(:has_wiki).filled :bool
          optional(:homepage).filled :string
          optional(:is_template).filled :bool
          optional(:license_template).filled :string
          optional(:private).filled :bool
          optional(:team_id).filled :integer
        end
      end
    end
  end
end
