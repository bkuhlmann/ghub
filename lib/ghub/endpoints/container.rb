# frozen_string_literal: true

require "containable"

module Ghub
  module Endpoints
    # Defines endpoint dependencies.
    module Container
      extend Containable

      register(:branch_protection) { Endpoints::Branches::Protection::Root.new }
      register(:branch_signature) { Endpoints::Branches::Signature::Root.new }
      register(:organization_members) { Endpoints::Organizations::Members::Root.new }
      register(:pulls) { Endpoints::Pulls::Root.new }
      register(:repositories) { Endpoints::Repositories::Root.new }
      register(:search_users) { Endpoints::Search::Users::Root.new }
      register(:users) { Endpoints::Users::Root.new }
    end
  end
end
