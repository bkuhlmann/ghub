# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Index do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#call" do
    context "with user" do
      before do
        body = [JSON(SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read)].to_json
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers success" do
        result = endpoint.call "users", "bkuhlmann"
        expect(result.success.first).to have_attributes(id: 11889072, name: "archiver")
      end
    end

    context "with organization" do
      before do
        body = SPEC_ROOT.join("support/fixtures/repositories/show-organization.json")
                        .read
                        .then { [JSON(it)] }
                        .to_json

        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers success" do
        result = endpoint.call "orgs", "alchemists"
        expect(result.success.first).to have_attributes(id: 510146886, name: "test")
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
        result = endpoint.call "users", "bkuhlmann"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
