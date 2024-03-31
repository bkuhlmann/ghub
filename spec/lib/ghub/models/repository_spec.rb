# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Repository do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/repositories/#{file}.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| Ghub::Responses::Repository.call body }
             .then(&:to_h)
    end

    context "with license, owner, and weight" do
      let(:file) { "show-user" }

      it "answers transformed keys" do
        expect(described_class.for(**body)).to have_attributes(
          license: kind_of(Ghub::Models::License),
          owner: kind_of(Ghub::Models::User),
          weight: kind_of(Integer)
        )
      end
    end

    context "with organization and permissions" do
      let(:file) { "create_or_patch" }

      it "answers transformed keys" do
        expect(described_class.for(**body)).to have_attributes(
          organization: kind_of(Ghub::Models::User),
          permissions: kind_of(Ghub::Models::Permissions::Repository)
        )
      end
    end

    context "with no license" do
      let(:file) { "show-user" }

      it "answers transformed keys" do
        body.delete :license
        expect(described_class.for(**body)).to have_attributes(license: nil)
      end
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
