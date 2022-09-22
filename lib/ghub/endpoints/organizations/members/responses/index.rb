# frozen_string_literal: true

module Ghub
  module Endpoints
    module Organizations
      module Members
        module Responses
          # Defines a collection of members.
          Index = Dry::Schema.Params { required(:body).array :hash, Ghub::Responses::User }
        end
      end
    end
  end
end
