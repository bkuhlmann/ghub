# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Actions::Index do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#call" do
    context "with success" do
      before do
        body = SPEC_ROOT.join("support/fixtures/pulls/index.json").read
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers pull request" do
        result = endpoint.call "bkuhlmann", "test", state: "all"
        expect(result.success.last).to have_attributes(id: 211207854, number: 1)
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

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "test"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
