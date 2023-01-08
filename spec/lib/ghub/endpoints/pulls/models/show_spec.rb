# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Models::Show do
  subject(:model) { described_class.new }

  include_examples "a result"

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/pulls/show.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
    end

    it "answers filled record when body exists" do
      expect(described_class.for(body)).to have_attributes(
        _links: kind_of(Ghub::Models::Links),
        assignee: kind_of(Ghub::Models::User),
        assignees: array_including(kind_of(Ghub::Models::User)),
        base: kind_of(Ghub::Models::Branch),
        head: kind_of(Ghub::Models::Branch),
        labels: array_including(kind_of(Ghub::Models::Label)),
        user: kind_of(Ghub::Models::User)
      )
    end

    it "answers nil for assignee when nil" do
      body[:assignee] = nil

      expect(described_class.for(body)).to have_attributes(
        _links: kind_of(Ghub::Models::Links),
        assignee: nil,
        assignees: array_including(kind_of(Ghub::Models::User)),
        base: kind_of(Ghub::Models::Branch),
        head: kind_of(Ghub::Models::Branch),
        labels: array_including(kind_of(Ghub::Models::Label)),
        user: kind_of(Ghub::Models::User)
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
