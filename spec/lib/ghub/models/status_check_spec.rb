# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::StatusCheck do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/branches/show.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.fetch :required_status_checks }
    end

    it "answers filled record when body exists" do
      expect(described_class.for(body)).to have_attributes(
        url: kind_of(String),
        strict: false,
        contexts: ["ci/circleci: build"],
        contexts_url: kind_of(String),
        checks: array_including(kind_of(Ghub::Models::Check)),
        enforcement_level: nil
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
