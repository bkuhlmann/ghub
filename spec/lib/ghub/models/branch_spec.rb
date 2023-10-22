# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Branch do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/pulls/show.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.fetch branch }
    end

    let :proof do
      {
        label: kind_of(String),
        ref: kind_of(String),
        repo: kind_of(Ghub::Models::Repository),
        sha: kind_of(String),
        user: kind_of(Ghub::Models::User)
      }
    end

    context "with base branch" do
      let(:branch) { :base }

      it "answers record" do
        expect(described_class.for(**body)).to have_attributes(proof)
      end
    end

    context "with head branch" do
      let(:branch) { :head }

      it "answers record" do
        expect(described_class.for(**body)).to have_attributes(proof)
      end
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
