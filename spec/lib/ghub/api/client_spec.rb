# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::API::Client do
  subject(:client) { described_class.new http: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#get" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {name: "test", private: false}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers body" do
        result = client.get "repos/bkuhlmann/test"
        expect(result.success.parse).to eq("name" => "test", "private" => false)
      end
    end

    context "with successful pagination (one)" do
      before do
        response = HTTP::Response.new headers: {
                                        content_type: "application/json",
                                        link: "<https://api.github.com/user/0/repos?page=9>; " \
                                              "rel=\"prev\", " \
                                              "<https://api.github.com/user/0/repos?page=1>; " \
                                              "rel=\"first\""
                                      },
                                      body: [{name: "test", private: false}].to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers body" do
        result = client.get "users/bkuhlmann/repos"

        expect(result.success.parse).to match(
          array_including(
            {
              "name" => "test",
              "private" => false
            }
          )
        )
      end
    end

    context "with successful pagination (many)" do
      subject :client do
        described_class.new configuration: Ghub::Configuration::Content[paginate: true], http:
      end

      before do
        response = HTTP::Response.new headers: {
                                        content_type: "application/json",
                                        link: "<https://api.github.com/user/0/repos?page=9>; " \
                                              "rel=\"prev\", " \
                                              "<https://api.github.com/user/0/repos?page=1>; " \
                                              "rel=\"first\""
                                      },
                                      body: [{name: "test", private: false}].to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers body" do
        result = client.get "users/bkuhlmann/repos"

        expect(result.success.parse).to match(
          array_including(
            {
              "name" => "test",
              "private" => false
            }
          )
        )
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {
                                        message: "Not Found",
                                        documentation_url: "https://docs.github.com/rest/reference"
                                      }.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers error" do
        result = client.get("orgs/test/members").failure

        expect(result.parse).to eq(
          "message" => "Not Found",
          "documentation_url" => "https://docs.github.com/rest/reference"
        )
      end
    end
  end

  describe "#post" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {name: "ghub-test", private: true}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers body" do
        result = client.post "user/repos", {name: "ghub-test", private: true}
        expect(result.success.parse).to include("name" => "ghub-test", "private" => true)
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {
                                        message: "Repository creation failed.",
                                        errors: [
                                          {
                                            code: "custom",
                                            field: "name",
                                            resource: "Repository",
                                            message: "name already exists on this account"
                                          }
                                        ]
                                      }.to_json,
                                      status: 422,
                                      version: 1.0

        allow(http).to receive(:post).and_return response
      end

      it "answers error" do
        result = client.post "user/repos", {name: "ghub-test", private: true}

        expect(result.failure.parse).to include(
          "message" => "Repository creation failed.",
          "errors" => [
            {
              "code" => "custom",
              "field" => "name",
              "resource" => "Repository",
              "message" => "name already exists on this account"
            }
          ]
        )
      end
    end
  end

  describe "#put" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {homepage: "https://example.com/ghub-test"}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:put).and_return response
      end

      it "answers body" do
        result = client.put "repos/bkuhlmann/ghub-test", {homepage: "https://example.com/ghub-test"}
        expect(result.success.parse).to include("homepage" => "https://example.com/ghub-test")
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
        result = client.put "repos/bkuhlmann/bogus", {description: "This is a test."}
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end

  describe "#patch" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {homepage: "https://example.com/ghub-test"}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:patch).and_return response
      end

      it "answers body" do
        result = client.patch "repos/bkuhlmann/ghub-test",
                              {homepage: "https://example.com/ghub-test"}

        expect(result.success.parse).to include("homepage" => "https://example.com/ghub-test")
      end
    end

    context "when not found" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {message: "Not Found"}.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:patch).and_return response
      end

      it "answers error" do
        result = client.patch "repos/bkuhlmann/bogus", {description: "This is a test."}
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end

  describe "#delete" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 204,
                                      version: 1.0

        allow(http).to receive(:delete).and_return response
      end

      it "answers body" do
        result = client.delete "repos/bkuhlmann/ghub-test"
        expect(result.success?).to be(true)
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
        result = client.delete "repos/bkuhlmann/bogus"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
