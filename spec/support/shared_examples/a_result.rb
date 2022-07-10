# frozen_string_literal: true

RSpec.shared_examples "a result" do
  include Dry::Monads[:result]

  describe ".call" do
    it "answers instance" do
      expect(described_class.call).to eq(described_class.new)
    end
  end

  describe "#to_monad" do
    it "answers monad" do
      expect(model.to_monad).to eq(Success(model))
    end
  end
end
