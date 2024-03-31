# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Search::Users::Models::Index do
  subject(:model) { described_class.new }

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
