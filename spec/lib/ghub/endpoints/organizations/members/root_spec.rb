# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Organizations::Members::Root do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#index" do
    let :http do
      HTTP::Fake::Client.new do
        get "/orgs/:owner/members" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            [
              {
                "avatar_url": "https://avatars.githubusercontent.com/u/50245?v=4",
                "events_url": "https://api.github.com/users/bkuhlmann/events{/privacy}",
                "followers_url": "https://api.github.com/users/bkuhlmann/followers",
                "following_url": "https://api.github.com/users/bkuhlmann/following{/other_user}",
                "gists_url": "https://api.github.com/users/bkuhlmann/gists{/gist_id}",
                "gravatar_id": null,
                "html_url": "https://github.com/bkuhlmann",
                "id": 50245,
                "login": "bkuhlmann",
                "node_id": "MDQ6VXNlcjUwMjQ1",
                "organizations_url": "https://api.github.com/users/bkuhlmann/orgs",
                "received_events_url": "https://api.github.com/users/bkuhlmann/received_events",
                "repos_url": "https://api.github.com/users/bkuhlmann/repos",
                "site_admin": false,
                "starred_url": "https://api.github.com/users/bkuhlmann/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/bkuhlmann/subscriptions",
                "type": "User",
                "url": "https://api.github.com/users/bkuhlmann"
              }
            ]
          JSON
        end
      end
    end

    it "answers success" do
      result = endpoint.index "alchemists"
      expect(result.success.first).to have_attributes(id: 50245, login: "bkuhlmann")
    end
  end
end
