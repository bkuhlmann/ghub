# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Protection::Actions::Show do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  describe "#call" do
    before { allow(http).to receive_messages(auth: http, headers: http) }

    context "with success" do
      before do
        body = SPEC_ROOT.join("support/fixtures/branches/show.json").read
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers pull request" do
        result = endpoint.call "bkuhlmann", "test", "main"

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

        allow(http).to receive(:get).and_return response
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "bogus", 1
        expect(result.failure.errors.to_h).to include(url: ["is missing"])
      end
    end

    context "when not found" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {message: "Not Found"}.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers error" do
        result = endpoint.call "bkuhlmann", "bogus", 1
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
