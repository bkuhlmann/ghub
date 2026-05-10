# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Users::Actions::Show do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    context "with success" do
      before do
        response = HTTP::Response.new(
          headers: {content_type: "application/json"},
          body: {
            login: "bkuhlmann",
            id: 50245,
            node_id: "MDQ6VXNlcjUwMjQ1",
            avatar_url: "https://avatars.githubusercontent.com/u/50245?v=4",
            gravatar_id: "",
            url: "https://api.github.com/users/bkuhlmann",
            html_url: "https://github.com/bkuhlmann",
            followers_url: "https://api.github.com/users/bkuhlmann/followers",
            following_url: "https://api.github.com/users/bkuhlmann/following{/other_user}",
            gists_url: "https://api.github.com/users/bkuhlmann/gists{/gist_id}",
            starred_url: "https://api.github.com/users/bkuhlmann/starred{/owner}{/repo}",
            subscriptions_url: "https://api.github.com/users/bkuhlmann/subscriptions",
            organizations_url: "https://api.github.com/users/bkuhlmann/orgs",
            repos_url: "https://api.github.com/users/bkuhlmann/repos",
            events_url: "https://api.github.com/users/bkuhlmann/events{/privacy}",
            received_events_url: "https://api.github.com/users/bkuhlmann/received_events",
            type: "User",
            site_admin: false,
            name: "Brooke Kuhlmann",
            company: "Alchemists",
            blog: "https://alchemists.io",
            location: "Boulder, CO USA",
            email: nil,
            hireable: nil,
            bio: "Quality over quantity.",
            twitter_username: nil,
            public_repos: 39,
            public_gists: 12,
            followers: 174,
            following: 0,
            created_at: "2009-01-29T17:24:54Z",
            updated_at: "2022-09-01T15:09:42Z"
          }.to_json,
          status: 200,
          version: 1.0
        )

        allow(http).to receive(:get).and_return response
      end

      it "answers success" do
        result = endpoint.call "bkuhlmann"
        expect(result.success).to have_attributes(id: 50245, login: "bkuhlmann")
      end
    end

    context "when empty" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers errors" do
        result = endpoint.call "test"
        expect(result.failure.errors.to_h).to include(id: ["is missing"])
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
        result = endpoint.call "test"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
