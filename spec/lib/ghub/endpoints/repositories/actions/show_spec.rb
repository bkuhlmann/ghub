# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Show do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    context "with user" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            Bundler.root.join("spec/support/fixtures/repositories/show-user.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call "bkuhlmann", "archiver"
        expect(result.success).to have_attributes(id: 11889072, name: "archiver")
      end
    end

    context "with organization" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            Bundler.root.join("spec/support/fixtures/repositories/show-organization.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call "alchemists", "ghub-test"
        expect(result.success).to have_attributes(id: 510146886, name: "test")
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "ghub-test"
        expect(result.failure.errors.to_h).to include(id: ["is missing"])
      end
    end

    context "when no found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:id" do
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
        result = endpoint.call "bkuhlmann", "ghub-test"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
