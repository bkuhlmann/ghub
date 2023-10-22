# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::BooleanLink do
  subject(:model) { described_class.new }

  describe ".for" do
    it "answers record" do
      expect(described_class.for(enabled: true, url: "https://test.com")).to have_attributes(
        enabled: true,
        url: "https://test.com"
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
