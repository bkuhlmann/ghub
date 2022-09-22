# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Users::Actions::Show do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#index" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:id" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "login": "bkuhlmann",
                "id": 50245,
                "node_id": "MDQ6VXNlcjUwMjQ1",
                "avatar_url": "https://avatars.githubusercontent.com/u/50245?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/bkuhlmann",
                "html_url": "https://github.com/bkuhlmann",
                "followers_url": "https://api.github.com/users/bkuhlmann/followers",
                "following_url": "https://api.github.com/users/bkuhlmann/following{/other_user}",
                "gists_url": "https://api.github.com/users/bkuhlmann/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/bkuhlmann/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/bkuhlmann/subscriptions",
                "organizations_url": "https://api.github.com/users/bkuhlmann/orgs",
                "repos_url": "https://api.github.com/users/bkuhlmann/repos",
                "events_url": "https://api.github.com/users/bkuhlmann/events{/privacy}",
                "received_events_url": "https://api.github.com/users/bkuhlmann/received_events",
                "type": "User",
                "site_admin": false,
                "name": "Brooke Kuhlmann",
                "company": "Alchemists",
                "blog": "https://www.alchemists.io",
                "location": "Boulder, CO USA",
                "email": null,
                "hireable": null,
                "bio": "Quality over quantity.",
                "twitter_username": null,
                "public_repos": 39,
                "public_gists": 12,
                "followers": 174,
                "following": 0,
                "created_at": "2009-01-29T17:24:54Z",
                "updated_at": "2022-09-01T15:09:42Z"
              }
            JSON
          end
        end
      end

      it "answers success" do
        result = endpoint.call "bkuhlmann"
        expect(result.success).to have_attributes(id: 50245, login: "bkuhlmann")
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "test"
        expect(result.failure.errors.to_h).to include(id: ["is missing"])
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/users/:id" do
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
        result = endpoint.call "test"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
