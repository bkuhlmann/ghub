# frozen_string_literal: true

module Ghub
  module Endpoints
    module Pulls
      module Responses
        # Defines a single pull request.
        Show = Dry::Schema.Params do
          required(:_links).hash Ghub::Responses::Links
          required(:active_lock_reason).maybe :string
          required(:assignee).maybe :hash, Ghub::Responses::User
          required(:assignees).array Ghub::Responses::User
          required(:author_association).filled :string
          required(:auto_merge).maybe :bool
          required(:base).hash Ghub::Responses::Branch
          required(:body).filled :string
          required(:closed_at).filled :string
          required(:comments_url).filled :string
          required(:commits_url).filled :string
          required(:created_at).filled :string
          required(:diff_url).filled :string
          required(:draft).filled :bool
          required(:head).hash Ghub::Responses::Branch
          required(:html_url).filled :string
          required(:id).filled :integer
          required(:issue_url).filled :string
          required(:labels).array Ghub::Responses::Label
          required(:locked).filled :bool
          required(:merge_commit_sha).filled :string
          required(:merged_at).maybe :date_time
          required(:milestone).maybe :hash
          required(:node_id).filled :string
          required(:number).filled :integer
          required(:patch_url).filled :string
          required(:requested_reviewers).maybe :array
          required(:requested_teams).maybe :array
          required(:review_comment_url).filled :string
          required(:review_comments_url).filled :string
          required(:state).filled :string
          required(:statuses_url).filled :string
          required(:title).filled :string
          required(:updated_at).filled :string
          required(:url).filled :string
          required(:user).hash Ghub::Responses::User

          optional(:additions).filled :integer
          optional(:changed_files).filled :integer
          optional(:comments).filled :integer
          optional(:commits).filled :integer
          optional(:deletions).filled :integer
          optional(:maintainer_can_modify).filled :bool
          optional(:mergable).filled :bool
          optional(:mergeable_state).filled :string
          optional(:merged).filled :bool
          optional(:merged_by).maybe :string
          optional(:rebaseable).filled :bool
          optional(:review_comments).filled :integer
        end
      end
    end
  end
end
