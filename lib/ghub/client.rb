# frozen_string_literal: true

require "inspectable"

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

    include Inspectable[
      branch_protection: :class,
      branch_signature: :class,
      organization_members: :class,
      pulls: :class,
      repositories: :class,
      search_users: :class,
      users: :class
    ]

    def initialize(**)
      super
      yield configuration if block_given?
    end
  end
end
