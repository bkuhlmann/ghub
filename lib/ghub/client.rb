# frozen_string_literal: true

module Ghub
  # The primary interface for making API requests.
  class Client
    include Dependencies[:configuration]

    include Endpoints::Dependencies.public(
      :branch_protection,
      :branch_signature,
      :organization_members,
      :pulls,
      :repositories,
      :search_users,
      :users
    )

    def initialize(**)
      super
      yield configuration if block_given?
    end
  end
end
