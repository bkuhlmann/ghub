# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::User do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/repositories/show-user.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.fetch :owner }
    end

    let :proof do
      described_class[
        avatar_url: "https://avatars.githubusercontent.com/u/50245?v=4",
        events_url: "https://api.github.com/users/bkuhlmann/events{/privacy}",
        followers_url: "https://api.github.com/users/bkuhlmann/followers",
        following_url: "https://api.github.com/users/bkuhlmann/following{/other_user}",
        gists_url: "https://api.github.com/users/bkuhlmann/gists{/gist_id}",
        gravatar_id: "",
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
      ]
    end

    it "answers record" do
      expect(described_class.for(**body)).to eq(proof)
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
