# frozen_string_literal: true

module Ghub
  module Endpoints
    module Repositories
      module Responses
        # Defines a repository within a collection.
        Index = Dry::Schema.Params { required(:body).array :hash, Show }
      end
    end
  end
end
