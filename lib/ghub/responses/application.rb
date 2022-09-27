# frozen_string_literal: true

module Ghub
  module Responses
    # Defines an application.
    Application = Dry::Schema.Params do
      required(:created_at).filled :date_time
      required(:description).filled :string
      required(:events).array(:str?)
      required(:external_url).filled :string
      required(:html_url).filled :string
      required(:id).filled :integer
      required(:name).filled :string
      required(:node_id).filled :string

      required(:owner).hash do
        required(:login).filled :string
        required(:id).filled :integer
        required(:node_id).filled :string
        required(:url).filled :string
        required(:repos_url).filled :string
        required(:events_url).filled :string
        required(:hooks_url).filled :string
        required(:issues_url).filled :string
        required(:members_url).filled :string
        required(:public_members_url).filled :string
        required(:avatar_url).filled :string
        required(:description).filled :string
      end

      required(:permissions).hash do
        required(:metadata).filled :string
        required(:contents).filled :string
        required(:issues).filled :string
        required(:single_file).filled :string
      end

      required(:slug).filled :string
      required(:updated_at).filled :date_time
    end
  end
end
