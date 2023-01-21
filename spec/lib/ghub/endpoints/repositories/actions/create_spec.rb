# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Create do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    context "with user" do
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 201
            SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call(:users, {name: "ghub-test", private: true})
        expect(result.success).to have_attributes(name: "ghub-test", private: true)
      end
    end

    context "with organization" do
      let :http do
        HTTP::Fake::Client.new do
          post "/orgs/:kind/repos" do
            headers["Content-Type"] = "application/json"
            status 201
            SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call(:orgs, {name: "ghub-test", private: true}, owner: "alchemists")
        expect(result.success).to have_attributes(name: "ghub-test", private: true)
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call(:users, {name: "ghub-test", private: true})
        expect(result.failure.errors.to_h).to include(allow_forking: ["is missing"])
      end
    end

    context "with invalid kind" do
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers error" do
        result = endpoint.call "danger", "test"
        expect(result.failure).to eq(%(Invalid kind: "danger". Use: "users" or "orgs".))
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {
                "message": "Not Found"
              }
            JSON
          end
        end
      end

      it "answers error" do
        result = endpoint.call "users", "test"
        expect(result.failure.errors.to_h).to eq(name: ["is missing"])
      end
    end
  end
end
