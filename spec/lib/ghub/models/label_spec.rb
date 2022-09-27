# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Label do
  subject(:model) { described_class.new }

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
