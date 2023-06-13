# frozen_string_literal: true

require "dry/monads"
require "refinements/arrays"

module Ghub
  module Endpoints
    module Repositories
      # Dynamically builds API repository path sfor users or organizations.
      class Path
        include Dry::Monads[:result]

        using Refinements::Arrays

        KINDS = %w[users orgs].freeze

        def initialize kinds: KINDS
          @kinds = kinds
        end

        def index kind, owner
          kinds.include?(kind.to_s) ? Success("#{kind}/#{owner}/repos") : error(kind)
        end

        def show(...) = resource(...)

        def create kind, owner: nil
          case kind.to_s
            when "users" then Success "user/repos"
            when "orgs"
              owner ? Success("orgs/#{owner}/repos") : Failure("Organization name is missing.")
            else error kind
          end
        end

        def patch(...) = resource(...)

        def destroy(...) = resource(...)

        private

        attr_reader :kinds

        def resource(owner, id) = Success "repos/#{owner}/#{id}"

        def error(kind) = Failure %(Invalid kind: #{kind.inspect}. Use: #{kinds.to_usage "or"}.)
      end
    end
  end
end
