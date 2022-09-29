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

          PATH = "repos/%{owner}/%{repository}/branches/%{branch}/protection/required_signatures"

          def initialize path: PATH, **dependencies
            super(**dependencies)
            @path = path
          end

          def show owner, repository, branch
            pipe format(path, owner:, repository:, branch:),
                 to(client, :get),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :new)
          end

          def create owner, repository, branch
            pipe format(path, owner:, repository:, branch:),
                 to(client, :post),
                 try(:parse, catch: JSON::ParserError),
                 validate(response),
                 to(model, :new)
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
