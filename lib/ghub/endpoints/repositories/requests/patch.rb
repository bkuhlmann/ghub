# frozen_string_literal: true

module Ghub
  module Endpoints
    module Repositories
      module Requests
        # Defines the data structure for patching a repository.
        Patch = Dry::Schema.JSON do
          optional(:allow_auto_merge).filled :bool
          optional(:allow_forking).filled :bool
          optional(:allow_merge_commit).filled :bool
          optional(:allow_rebase_merge).filled :bool
          optional(:allow_squash_merge).filled :bool
          optional(:archived).filled :bool
          optional(:default_branch).filled :string
          optional(:delete_branch_on_merge).filled :bool
          optional(:description).filled :string
          optional(:has_issues).filled :bool
          optional(:has_projects).filled :bool
          optional(:has_wiki).filled :bool
          optional(:homepage).filled :string
          optional(:is_template).filled :bool
          optional(:name).filled :string
          optional(:private).filled :bool

          optional(:security_and_analysis).hash do
            optional(:advanced_security).hash { required(:status).filled :string }
            optional(:secret_scanning).hash { required(:status).filled :string }
            optional(:secret_scanning_push_protection).hash { required(:status).filled :string }
          end

          optional(:use_squash_pr_title_as_default).filled :bool
          optional(:visibility).filled :bool
        end
      end
    end
  end
end
