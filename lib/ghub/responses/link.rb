# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a link.
    Link = Dry::Schema.Params { required(:href).filled :string }
  end
end
