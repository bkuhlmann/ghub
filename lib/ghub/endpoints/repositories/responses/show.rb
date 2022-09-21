# frozen_string_literal: true

module Ghub
  module Endpoints
    module Repositories
      module Responses
        # Defines a repository.
        Show = Dry::Schema.Params do
          required(:allow_forking).filled :bool
          required(:archive_url).filled :string
          required(:archived).filled :bool
          required(:assignees_url).filled :string
          required(:blobs_url).filled :string
          required(:branches_url).filled :string
          required(:clone_url).filled :string
          required(:collaborators_url).filled :string
          required(:comments_url).filled :string
          required(:commits_url).filled :string
          required(:compare_url).filled :string
          required(:contents_url).filled :string
          required(:contributors_url).filled :string
          required(:created_at).filled :date_time
          required(:default_branch).filled :string
          required(:deployments_url).filled :string
          required(:description).maybe :string
          required(:disabled).filled :bool
          required(:downloads_url).filled :string
          required(:events_url).filled :string
          required(:fork).filled :bool
          required(:forks).filled :integer
          required(:forks_count).filled :integer
          required(:forks_url).filled :string
          required(:full_name).filled :string
          required(:git_commits_url).filled :string
          required(:git_refs_url).filled :string
          required(:git_tags_url).filled :string
          required(:git_url).filled :string
          required(:has_downloads).filled :bool
          required(:has_issues).filled :bool
          required(:has_pages).filled :bool
          required(:has_projects).filled :bool
          required(:has_wiki).filled :bool
          required(:homepage).maybe :string
          required(:hooks_url).filled :string
          required(:html_url).filled :string
          required(:id).filled :integer
          required(:is_template).filled :bool
          required(:issue_comment_url).filled :string
          required(:issue_events_url).filled :string
          required(:issues_url).filled :string
          required(:keys_url).filled :string
          required(:labels_url).filled :string
          required(:language).maybe :string
          required(:languages_url).filled :string
          required(:license).maybe :hash, Ghub::Responses::License
          required(:merges_url).filled :string
          required(:milestones_url).filled :string
          required(:mirror_url).maybe :string
          required(:name).filled :string
          required(:node_id).filled :string
          required(:notifications_url).filled :string
          required(:open_issues).filled :integer
          required(:open_issues_count).filled :integer
          required(:owner).hash Ghub::Responses::User
          required(:private).filled :bool
          required(:pulls_url).filled :string
          required(:pushed_at).filled :date_time
          required(:releases_url).filled :string
          required(:size).filled :integer
          required(:ssh_url).filled :string
          required(:stargazers_count).filled :integer
          required(:stargazers_url).filled :string
          required(:statuses_url).filled :string
          required(:subscribers_url).filled :string
          required(:subscription_url).filled :string
          required(:svn_url).filled :string
          required(:tags_url).filled :string
          required(:teams_url).filled :string
          required(:topics).array(:str?)
          required(:trees_url).filled :string
          required(:updated_at).filled :date_time
          required(:url).filled :string
          required(:visibility).filled :string
          required(:watchers).filled :integer
          required(:watchers_count).filled :integer
          required(:web_commit_signoff_required).filled :bool

          optional(:network_count).filled :integer
          optional(:organization).hash Ghub::Responses::User
          optional(:permissions).hash Ghub::Responses::Permission
          optional(:subscribers_count).filled :integer
          optional(:temp_clone_token).maybe :string
        end
      end
    end
  end
end
