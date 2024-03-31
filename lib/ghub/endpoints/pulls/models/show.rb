# frozen_string_literal: true

module Ghub
  module Endpoints
    module Pulls
      module Models
        # Defines a single pull request.
        Show = Struct.new(
          :_links,
          :active_lock_reason,
          :additions,
          :assignee,
          :assignees,
          :author_association,
          :auto_merge,
          :base,
          :body,
          :changed_files,
          :closed_at,
          :comments,
          :comments_url,
          :commits,
          :commits_url,
          :created_at,
          :deletions,
          :diff_url,
          :draft,
          :head,
          :html_url,
          :id,
          :issue_url,
          :labels,
          :locked,
          :maintainer_can_modify,
          :mergeable,
          :merge_commit_sha,
          :mergeable_state,
          :merged,
          :merged_at,
          :merged_by,
          :milestone,
          :node_id,
          :number,
          :patch_url,
          :rebaseable,
          :requested_reviewers,
          :requested_teams,
          :review_comment_url,
          :review_comments,
          :review_comments_url,
          :state,
          :statuses_url,
          :title,
          :updated_at,
          :url,
          :user
        ) do
          def self.for(**attributes)
            assignee = attributes[:assignee]

            new(
              **attributes.merge!(
                _links: Ghub::Models::Links.for(**attributes[:_links]),
                assignee: (Ghub::Models::User[**assignee] if assignee),
                assignees: attributes[:assignees].map { |data| Ghub::Models::User[**data] },
                base: Ghub::Models::Branch[**attributes[:base]],
                head: Ghub::Models::Branch[**attributes[:head]],
                labels: attributes[:labels].map { |data| Ghub::Models::Label[**data] },
                user: Ghub::Models::User[**attributes[:user]]
              )
            )
          end

          def initialize(**)
            super
            freeze
          end
        end
      end
    end
  end
end
