# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Patch do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  describe "#call" do
    context "with user" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call "bkuhlmann", "ghub-test", {description: "For test only."}

        expect(result.success).to have_attributes(
          name: "ghub-test",
          description: "For test only."
        )
      end
    end

    context "with organization" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 201
            SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
          end
        end
      end

      it "answers success" do
        result = endpoint.call "alchemists", "ghub-test", {description: "For test only."}

        expect(result.success).to have_attributes(
          name: "ghub-test",
          description: "For test only."
        )
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "alchemists", "ghub-test", {description: "For test only."}
        expect(result.failure.errors.to_h).to include(id: ["is missing"])
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:id" do
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
        result = endpoint.call "bkuhlmann", "ghub-test", {description: "For test only."}
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
