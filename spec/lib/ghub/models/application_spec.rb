# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Application do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/branches/show-full.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.dig :restrictions, :apps, 0 }
    end

    it "answers record" do
      expect(described_class.for(**body)).to have_attributes(
        created_at: kind_of(String),
        description: "",
        events: %w[push pull_request],
        external_url: kind_of(String),
        html_url: kind_of(String),
        id: kind_of(Integer),
        name: "Octocat App",
        node_id: kind_of(String),
        owner: kind_of(Ghub::Models::Owner),
        permissions: kind_of(Ghub::Models::Permissions::Branch),
        slug: "octoapp",
        updated_at: kind_of(String)
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
