# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Users::Models::Index do
  subject(:model) { described_class.new }

  include_examples "a result"

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
