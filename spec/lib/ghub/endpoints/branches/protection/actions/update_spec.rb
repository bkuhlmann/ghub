# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Protection::Actions::Update do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    let :body do
      {
        enforce_admins: false,
        restrictions: nil,
        required_status_checks: {
          strict: false,
          contexts: ["ci/circleci: build"]
        },
        required_pull_request_reviews: nil,
        required_linear_history: true
      }
    end

    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          put "/repos/:owner/:repository/branches/:branch/protection" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              #{Bundler.root.join("spec/support/fixtures/branches/show.json").read}
            JSON
          end
        end
      end

      it "answers pull request" do
        result = endpoint.call "bkuhlmann", "test", "main", body

        expect(result.success).to have_attributes(
          allow_deletions: {enabled: false},
          allow_force_pushes: {enabled: false},
          block_creations: {enabled: false},
          enforce_admins: kind_of(Ghub::Models::BooleanLink),
          required_conversation_resolution: {enabled: false},
          required_linear_history: {enabled: true},
          required_signatures: kind_of(Ghub::Models::BooleanLink),
          required_status_checks: kind_of(Ghub::Models::StatusCheck),
          url: kind_of(String)
        )
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          put "/repos/:owner/:repository/branches/:branch/protection" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "bogus", 1, body
        expect(result.failure.errors.to_h).to include(url: ["is missing"])
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          put "/repos/:owner/:repository/branches/:branch/protection" do
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
        result = endpoint.call "bkuhlmann", "bogus", 1, body
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
