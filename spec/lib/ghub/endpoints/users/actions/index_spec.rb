# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Users::Actions::Index do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  describe "#index" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              [
                {
                  "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
                  "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
                  "followers_url": "https://api.github.com/users/mojombo/followers",
                  "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
                  "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
                  "gravatar_id": "",
                  "html_url": "https://github.com/mojombo",
                  "id": 1,
                  "login": "mojombo",
                  "node_id": "MDQ6VXNlcjE",
                  "organizations_url": "https://api.github.com/users/mojombo/orgs",
                  "received_events_url": "https://api.github.com/users/mojombo/received_events",
                  "repos_url": "https://api.github.com/users/mojombo/repos",
                  "site_admin": false,
                  "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
                  "type": "User",
                  "url": "https://api.github.com/users/mojombo"
                }
              ]
            JSON
          end
        end
      end

      it "answers success" do
        result = endpoint.call
        expect(result.success.first).to have_attributes(id: 1, login: "mojombo")
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users" do
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
        result = endpoint.call
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
