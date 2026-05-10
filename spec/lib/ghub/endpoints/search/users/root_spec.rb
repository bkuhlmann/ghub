# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Search::Users::Root do
  subject(:endpoint) { described_class.new index_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Search::Users::Actions::Index.new api: }

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    context "with success" do
      before do
        response = HTTP::Response.new(
          headers: {content_type: "application/json"},
          body: {
            total_count: 1,
            incomplete_results: false,
            items: [
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
                score: 1.0,
                site_admin: false,
                starred_url: "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
                subscriptions_url: "https://api.github.com/users/mojombo/subscriptions",
                type: "User",
                url: "https://api.github.com/users/mojombo"
              }
            ]
          }.to_json,
          status: 200,
          version: 1.0
        )

        allow(http).to receive(:get).and_return response
      end

      it "answers success" do
        result = endpoint.index q: "mojombo", per_page: 1
        expect(result.success.first).to have_attributes(id: 1, login: "mojombo")
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {
                                        total_count: 0,
                                        incomplete_results: false,
                                        items: []
                                      }.to_json,
                                      status: 200,
                                      version: 1.0

        allow(http).to receive(:get).and_return response
      end

      it "answers errors" do
        result = endpoint.index q: "@#$%"
        expect(result.success.to_h).to eq({})
      end
    end
  end
end
