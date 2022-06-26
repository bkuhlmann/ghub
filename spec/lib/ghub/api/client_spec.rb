# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::API::Client do
  subject(:client) { described_class.new http: }

  describe "#get" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:user_id/:id" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "name": "test",
                "private": false
              }
            JSON
          end
        end
      end

      it "answers body" do
        result = client.get "repos/bkuhlmann/test"
        expect(result.success.parse).to eq("name" => "test", "private" => false)
      end
    end

    context "with successful pagination (one)" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:owner/repos" do
            headers["Content-Type"] = "application/json"
            headers["Link"] = "<https://api.github.com/user/0/repos?page=9>; rel=\"prev\", " \
                              "<https://api.github.com/user/0/repos?page=1>; rel=\"first\""
            status 200

            <<~JSON
              [
                {
                  "name": "test",
                  "private": false
                }
              ]
            JSON
          end
        end
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

      let :http do
        HTTP::Fake::Client.new do
          get "/users/:owner/repos" do
            headers["Content-Type"] = "application/json"
            headers["Link"] = "<https://api.github.com/user/0/repos?page=9>; rel=\"prev\", " \
                              "<https://api.github.com/user/0/repos?page=1>; rel=\"first\""
            status 200

            <<~JSON
              [
                {
                  "name": "test",
                  "private": false
                }
              ]
            JSON
          end
        end
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
      let :http do
        HTTP::Fake::Client.new do
          get "/orgs/test/members" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {
                "message": "Not Found",
                "documentation_url": "https://docs.github.com/rest/reference"
              }
            JSON
          end
        end
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
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "name": "ghub-test",
                "private": true
              }
            JSON
          end
        end
      end

      it "answers body" do
        result = client.post "user/repos", {name: "ghub-test", private: true}
        expect(result.success.parse).to include("name" => "ghub-test", "private" => true)
      end
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          post "/user/repos" do
            headers["Content-Type"] = "application/json"
            status 422

            <<~JSON
              {
                "message": "Repository creation failed.",
                "errors": [
                  {
                    "code": "custom",
                    "field": "name",
                    "resource": "Repository",
                    "message": "name already exists on this account"
                  }
                ]
              }
            JSON
          end
        end
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
      let :http do
        HTTP::Fake::Client.new do
          put "/repos/:owner/:repository" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "homepage": "https://example.com/ghub-test"
              }
            JSON
          end
        end
      end

      it "answers body" do
        result = client.put "repos/bkuhlmann/ghub-test", {homepage: "https://example.com/ghub-test"}
        expect(result.success.parse).to include("homepage" => "https://example.com/ghub-test")
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          put "/repos/:owner/:repository" do
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
        result = client.put "repos/bkuhlmann/bogus", {description: "This is a test."}
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end

  describe "#patch" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:repository" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "homepage": "https://example.com/ghub-test"
              }
            JSON
          end
        end
      end

      it "answers body" do
        result = client.patch "repos/bkuhlmann/ghub-test",
                              {homepage: "https://example.com/ghub-test"}

        expect(result.success.parse).to include("homepage" => "https://example.com/ghub-test")
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          patch "/repos/:owner/:repository" do
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
        result = client.patch "repos/bkuhlmann/bogus", {description: "This is a test."}
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end

  describe "#delete" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:repository" do
            headers["Content-Type"] = "application/json"
            status 204
          end
        end
      end

      it "answers body" do
        result = client.delete "repos/bkuhlmann/ghub-test"
        expect(result.success?).to be(true)
      end
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:repository" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"message": "Not Found"}
            JSON
          end
        end
      end

      it "answers error" do
        result = client.delete "repos/bkuhlmann/bogus"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
