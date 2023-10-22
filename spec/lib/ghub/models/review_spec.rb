# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Review do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/branches/show-full.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.fetch :required_pull_request_reviews }
    end

    it "answers empty record when given nil" do
      expect(described_class.for).to have_attributes(
        dismiss_stale_reviews: nil,
        require_code_owner_reviews: nil,
        required_approving_review_count: nil,
        url: nil,
        dismissal_restrictions: nil
      )
    end

    it "answers filled record when body exists" do
      expect(described_class.for(**body)).to have_attributes(
        dismiss_stale_reviews: true,
        require_code_owner_reviews: true,
        required_approving_review_count: 2,
        url: kind_of(String),
        dismissal_restrictions: kind_of(Ghub::Models::DismissalRestriction)
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
