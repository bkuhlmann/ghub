# frozen_string_literal: true

module Ghub
  module Models
    # Defines a repository.
    Repository = Struct.new(
      :allow_forking,
      :archive_url,
      :archived,
      :assignees_url,
      :blobs_url,
      :branches_url,
      :clone_url,
      :collaborators_url,
      :comments_url,
      :commits_url,
      :compare_url,
      :contents_url,
      :contributors_url,
      :created_at,
      :default_branch,
      :deployments_url,
      :description,
      :disabled,
      :downloads_url,
      :events_url,
      :fork,
      :forks,
      :forks_count,
      :forks_url,
      :full_name,
      :git_commits_url,
      :git_refs_url,
      :git_tags_url,
      :git_url,
      :has_downloads,
      :has_issues,
      :has_pages,
      :has_projects,
      :has_wiki,
      :homepage,
      :hooks_url,
      :html_url,
      :id,
      :is_template,
      :issue_comment_url,
      :issue_events_url,
      :issues_url,
      :keys_url,
      :labels_url,
      :language,
      :languages_url,
      :license,
      :merges_url,
      :milestones_url,
      :mirror_url,
      :name,
      :network_count,
      :node_id,
      :notifications_url,
      :open_issues,
      :open_issues_count,
      :organization,
      :owner,
      :permissions,
      :private,
      :pulls_url,
      :pushed_at,
      :releases_url,
      :ssh_url,
      :stargazers_count,
      :stargazers_url,
      :statuses_url,
      :subscribers_count,
      :subscribers_url,
      :subscription_url,
      :svn_url,
      :tags_url,
      :teams_url,
      :temp_clone_token,
      :topics,
      :trees_url,
      :updated_at,
      :url,
      :visibility,
      :watchers,
      :watchers_count,
      :web_commit_signoff_required,
      :weight
    ) do
      include Resultable

      def self.for(**attributes)
        new(
          **attributes.transform_keys!(size: :weight).merge(
            license: (License[**Hash(attributes[:license])] if attributes.key? :license),
            owner: User[**attributes[:owner]],
            organization: (User[**attributes[:organization]] if attributes.key? :organization),
            permissions: (
              Permissions::Repository[**attributes[:permissions]] if attributes.key? :permissions
            )
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
