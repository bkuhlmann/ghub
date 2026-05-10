# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Users::Root do
  subject(:endpoint) { described_class.new index_action:, show_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Users::Actions::Index.new api: }
  let(:show_action) { Ghub::Endpoints::Users::Actions::Show.new api: }

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    context "with success" do
      before do
        response = HTTP::Response.new(
          headers: {content_type: "application/json"},
          body: [
            {
              avatar_url: "https://avatars.githubusercontent.com/u/1?v=4",
              events_url: "https://api.github.com/users/mojombo/events{/privacy}",
              followers_url: "https://api.github.com/users/mojombo/followers",
              following_url: "https://api.github.com/users/mojombo/following{/other_user}",
              gists_url: "https://api.github.com/users/mojombo/gists{/gist_id}",
              gravatar_id: "",
              html_url: "https://github.com/mojombo",
              id: 1,
              login: "mojombo",
              node_id: "MDQ6VXNlcjE",
              organizations_url: "https://api.github.com/users/mojombo/orgs",
              received_events_url: "https://api.github.com/users/mojombo/received_events",
              repos_url: "https://api.github.com/users/mojombo/repos",
              site_admin: false,
              starred_url: "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
              subscriptions_url: "https://api.github.com/users/mojombo/subscriptions",
              type: "User",
              url: "https://api.github.com/users/mojombo"
            }
          ].to_json,
          status: 200,
          version: 1.0
        )

        allow(http).to receive(:get).and_return response
      end

      it "answers success" do
        result = endpoint.index
        expect(result.success.first).to have_attributes(id: 1, login: "mojombo")
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: [{}].to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers errors" do
        result = endpoint.index

        expect(result.failure.errors.to_h).to include(
          body: {
            0 => hash_including(avatar_url: ["is missing"], url: ["is missing"])
          }
        )
      end
    end
  end

  describe "#show" do
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
        result = endpoint.show "bkuhlmann"
        expect(result.success).to have_attributes(id: 50245, login: "bkuhlmann")
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers errors" do
        result = endpoint.show "test"
        expect(result.failure.errors.to_h).to include(name: ["is missing"], email: ["is missing"])
      end
    end
  end
end
