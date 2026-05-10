# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Signature::Root do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#show" do
    before do
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body: {
                                      url: "https://api.github.com/repos/bkuhlmann/test" \
                                           "/branches/main/protection/required_signatures",
                                      enabled: true
                                    }.to_json,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return response
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#create" do
    before do
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body: {
                                      url: "https://api.github.com/repos/bkuhlmann/test" \
                                           "/branches/main/protection/required_signatures",
                                      enabled: true
                                    }.to_json,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:post).and_return response
    end

    it "answers pull request" do
      result = endpoint.create "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#destroy" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      status: 204,
                                      version: 1.0

        allow(http).to receive(:delete).and_return response
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

        allow(http).to receive(:delete).and_return response
      end

      it "answers error" do
        result = endpoint.destroy "bkuhlmann", "test", "main"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
