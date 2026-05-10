# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Organizations::Members::Actions::Index do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    context "with success" do
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
        result = endpoint.call "alchemists"
        expect(result.success.first).to have_attributes(id: 50245, login: "bkuhlmann")
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

      it "answers errors" do
        result = endpoint.call :bogus
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
