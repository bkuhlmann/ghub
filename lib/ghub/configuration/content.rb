# frozen_string_literal: true

module Ghub
  module Configuration
    # Defines the client configuration content for API requests.
    Content = Struct.new :accept, :paginate, :token, :url
  end
end
