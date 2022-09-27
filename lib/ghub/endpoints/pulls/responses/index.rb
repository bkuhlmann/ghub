# frozen_string_literal: true

module Ghub
  module Endpoints
    module Pulls
      module Responses
        # Defines a collection of pull requests.
        Index = Dry::Schema.Params { required(:body).array :hash, Show }
      end
    end
  end
end
