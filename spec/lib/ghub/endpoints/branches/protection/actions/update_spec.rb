# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Protection::Actions::Update do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  describe "#call" do
    before { allow(http).to receive_messages(auth: http, headers: http) }

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
      before do
        body = SPEC_ROOT.join("support/fixtures/branches/show.json").read
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:put).and_return response
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
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:put).and_return response
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "bogus", 1, body
        expect(result.failure.errors.to_h).to include(url: ["is missing"])
      end
    end

    context "when not found" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {message: "Not Found"}.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:put).and_return response
      end

      it "answers error" do
        result = endpoint.call "bkuhlmann", "bogus", 1, body
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
