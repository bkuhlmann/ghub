# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Protection::Root do
  subject(:endpoint) { described_class.new api:, show_action:, update_action: }

  include_context "with application dependencies"

  let(:show_action) { Ghub::Endpoints::Branches::Protection::Actions::Show.new api: }
  let(:update_action) { Ghub::Endpoints::Branches::Protection::Actions::Update.new api: }

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#show" do
    before do
      body = SPEC_ROOT.join("support/fixtures/branches/show.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return(response)
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#update" do
    before do
      body = SPEC_ROOT.join("support/fixtures/branches/show.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:put).and_return(response)
    end

    it "answers success" do
      result = endpoint.update(
        "bkuhlmann",
        "test",
        "main",
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
      )

      expect(result.success).to have_attributes(required_linear_history: {enabled: true})
    end
  end

  describe "#destroy" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      status: 204,
                                      version: 1.0

        allow(http).to receive(:delete).and_return(response)
      end

      it "answers no content" do
        result = endpoint.destroy "bkuhlmann", "test", "main"
        expect(result.success.status.code).to eq(204)
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {message: "Not Found"}.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:delete).and_return(response)
      end

      it "answers error" do
        result = endpoint.destroy "bkuhlmann", "test", "main"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
