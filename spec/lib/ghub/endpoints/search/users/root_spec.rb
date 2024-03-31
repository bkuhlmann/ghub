# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Search::Users::Root do
  subject(:endpoint) { described_class.new index_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Search::Users::Actions::Index.new api: }

  describe "#index" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/search/users" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "total_count": 3,
                "incomplete_results": false,
                "items": [
                  {
                    "login": "mojombo",
                    "id": 1,
                    "node_id": "MDQ6VXNlcjE=",
                    "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/mojombo",
                    "html_url": "https://github.com/mojombo",
                    "followers_url": "https://api.github.com/users/mojombo/followers",
                    "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
                    "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
                    "organizations_url": "https://api.github.com/users/mojombo/orgs",
                    "repos_url": "https://api.github.com/users/mojombo/repos",
                    "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/mojombo/received_events",
                    "type": "User",
                    "site_admin": false,
                    "score": 1.0
                  }
                ]
              }
            JSON
          end
        end
      end

      it "answers success" do
        result = endpoint.index q: "mojombo", per_page: 1
        expect(result.success.first).to have_attributes(id: 1, login: "mojombo")
      end
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          get "/search/users" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              {
                "total_count": 0,
                "incomplete_results": false,
                "items": []
              }
            JSON
          end
        end
      end

      it "answers errors" do
        result = endpoint.index q: "@#$%"
        expect(result.success.to_h).to eq({})
      end
    end
  end
end
