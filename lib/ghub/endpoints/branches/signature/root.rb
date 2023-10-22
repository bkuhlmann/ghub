# frozen_string_literal: true

require "transactable"

module Ghub
  module Endpoints
    module Branches
      module Signature
        # Provides access to the branch signature API endpoint.
        class Root
          include Signature::Import[:client, response: "responses.show", model: "models.show"]
          include Transactable

          PATH = "repos/%<owner>s/%<repository>s/branches/%<branch>s/protection/required_signatures"

          def initialize(path: PATH, **)
            super(**)
            @path = path
          end

          def show owner, repository, branch
            pipe format(path, owner:, repository:, branch:),
                 to(client, :get),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :for)
          end

          def create owner, repository, branch
            pipe format(path, owner:, repository:, branch:),
                 to(client, :post),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :for)
          end

          def destroy owner, repository, branch
            client.delete format(path, owner:, repository:, branch:)
          end

          private

          attr_reader :path
        end
      end
    end
  end
end
