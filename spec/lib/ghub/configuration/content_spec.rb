# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Configuration::Content do
  subject(:content) { described_class[token: "secret"] }

  describe "#inspect" do
    it "answers redacted token" do
      expect(content.inspect).to eq(
        %(#<struct Ghub::Configuration::Content accept=nil, paginate=nil, ) +
        %(token="[REDACTED]", url=nil>)
      )
    end
  end
end
