# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a restriction.
    Restriction = Dry::Schema.Params do
      required(:apps).array(Application)
      required(:apps_url).filled :string
      required(:teams).array(Team)
      required(:teams_url).filled :string
      required(:url).filled :string
      required(:users).array(User)
      required(:users_url).filled :string
    end
  end
end
