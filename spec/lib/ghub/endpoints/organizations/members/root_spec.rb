# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Organizations::Members::Root do
  subject(:endpoint) { described_class.new index_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Organizations::Members::Actions::Index.new api: }

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    before do
      response = HTTP::Response.new(
        headers: {content_type: "application/json"},
        body: [
          {
            avatar_url: "https://avatars.githubusercontent.com/u/50245?v=4",
            events_url: "https://api.github.com/users/bkuhlmann/events{/privacy}",
            followers_url: "https://api.github.com/users/bkuhlmann/followers",
            following_url: "https://api.github.com/users/bkuhlmann/following{/other_user}",
            gists_url: "https://api.github.com/users/bkuhlmann/gists{/gist_id}",
            gravatar_id: nil,
            html_url: "https://github.com/bkuhlmann",
            id: 50245,
            login: "bkuhlmann",
            node_id: "MDQ6VXNlcjUwMjQ1",
            organizations_url: "https://api.github.com/users/bkuhlmann/orgs",
            received_events_url: "https://api.github.com/users/bkuhlmann/received_events",
            repos_url: "https://api.github.com/users/bkuhlmann/repos",
            site_admin: false,
            starred_url: "https://api.github.com/users/bkuhlmann/starred{/owner}{/repo}",
            subscriptions_url: "https://api.github.com/users/bkuhlmann/subscriptions",
            type: "User",
            url: "https://api.github.com/users/bkuhlmann"
          }
        ].to_json,
        status: 200,
        version: 1.0
      )

      allow(http).to receive(:get).and_return response
    end

    it "answers success" do
      result = endpoint.index "alchemists"
      expect(result.success.first).to have_attributes(id: 50245, login: "bkuhlmann")
    end
  end
end
