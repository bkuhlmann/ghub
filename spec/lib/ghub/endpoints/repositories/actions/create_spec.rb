# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Actions::Create do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#call" do
    context "with user" do
      before do
        body = SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 201,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers success" do
        result = endpoint.call(:users, {name: "ghub-test", private: true})
        expect(result.success).to have_attributes(name: "ghub-test", private: true)
      end
    end

    context "with organization" do
      before do
        body = SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body:,
                                      status: 201,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers success" do
        result = endpoint.call(:orgs, {name: "ghub-test", private: true}, owner: "alchemists")
        expect(result.success).to have_attributes(name: "ghub-test", private: true)
      end
    end

    context "when empty" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers errors" do
        result = endpoint.call(:users, {name: "ghub-test", private: true})
        expect(result.failure.errors.to_h).to include(allow_forking: ["is missing"])
      end
    end

    context "with invalid kind" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers error" do
        result = endpoint.call "danger", "test"
        expect(result.failure).to eq(%(Invalid kind: "danger". Use: "users" or "orgs".))
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
        result = endpoint.call "users", "test"
        expect(result.failure.errors.to_h).to eq(name: ["is missing"])
      end
    end
  end
end
