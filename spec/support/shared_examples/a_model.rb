# frozen_string_literal: true

RSpec.shared_examples "a model" do
  it "answers frozen instance" do
    expect(model.frozen?).to be(true)
  end
end
