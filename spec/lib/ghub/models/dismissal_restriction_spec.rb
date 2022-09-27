# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::DismissalRestriction do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/branches/show-full.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.dig :required_pull_request_reviews, :dismissal_restrictions }
    end

    it "answers empty record when given nil" do
      expect(described_class.for(nil)).to have_attributes(
        apps: nil,
        teams: nil,
        teams_url: nil,
        url: nil,
        users: nil,
        users_url: nil
      )
    end

    it "answers filled record when body exists" do
      expect(described_class.for(body)).to have_attributes(
        apps: array_including(kind_of(Ghub::Models::Application)),
        teams: array_including(kind_of(Ghub::Models::Team)),
        teams_url: kind_of(String),
        url: kind_of(String),
        users: array_including(kind_of(Ghub::Models::User)),
        users_url: kind_of(String)
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
