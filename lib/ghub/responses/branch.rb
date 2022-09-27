# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a branch.
    Branch = Dry::Schema.Params do
      required(:label).filled :string
      required(:ref).filled :string
      required(:sha).filled :string
      required(:user).hash(Ghub::Responses::User)
      required(:repo).hash(Ghub::Responses::Repository)
    end
  end
end
