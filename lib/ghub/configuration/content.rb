# frozen_string_literal: true

require "inspectable"

module Ghub
  module Configuration
    # Defines the client configuration content for API requests.
    Content = Struct.new(:accept, :paginate, :token, :url) { include Inspectable[token: :redact] }
  end
end
