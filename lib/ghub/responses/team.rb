# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a team.
    Team = Dry::Schema.Params do
      required(:description).filled :string
      required(:id).filled :integer
      required(:members_url).filled :string
      required(:name).filled :string
      required(:node_id).filled :string
      required(:parent).maybe :string
      required(:permission).filled :string
      required(:privacy).filled :string
      required(:repositories_url).filled :string
      required(:slug).filled :string
      required(:url).filled :string
    end
  end
end
