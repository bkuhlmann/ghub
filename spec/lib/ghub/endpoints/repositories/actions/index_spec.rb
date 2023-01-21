# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Index do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    context "with user" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:owner/repos" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              [#{SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read}]
            JSON
          end
        end
      end

      it "answers success" do
        result = endpoint.call "users", "bkuhlmann"
        expect(result.success.first).to have_attributes(id: 11889072, name: "archiver")
      end
    end

    context "with organization" do
      let :http do
        HTTP::Fake::Client.new do
          get "/orgs/:owner/repos" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              [
                #{Bundler.root
                         .join("spec/support/fixtures/repositories/show-organization.json")
                         .read
                }
              ]
            JSON
          end
        end
      end

      it "answers success" do
        result = endpoint.call "orgs", "alchemists"
        expect(result.success.first).to have_attributes(id: 510146886, name: "test")
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:owner/repos" do
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
        result = endpoint.call "users", "bkuhlmann"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
