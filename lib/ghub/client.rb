# frozen_string_literal: true

module Ghub
  # The primary interface for making API requests.
  class Client
    include Import[:configuration]

    include Endpoints::Import[
      branch_protection_endpoint: :branch_protection,
      branch_signature_endpoint: :branch_signature,
      organization_members_endpoint: :organization_members,
      pulls_endpoint: :pulls,
      repositories_endpoint: :repositories,
      users_endpoint: :users
    ]

    def initialize(**)
      super(**)
      yield configuration if block_given?
    end

    def branch_protection = branch_protection_endpoint

    def branch_signature = branch_signature_endpoint

    def organization_members = organization_members_endpoint

    def pulls = pulls_endpoint

    def repositories = repositories_endpoint

    def users = users_endpoint
  end
end
