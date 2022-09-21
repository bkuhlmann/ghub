# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Path do
  subject(:path) { described_class.new }

  describe "#index" do
    it "answers user path when kind is a string" do
      expect(path.index("users", "test").success).to eq("users/test/repos")
    end

    it "answers user path when kind is a symbol" do
      expect(path.index(:users, "test").success).to eq("users/test/repos")
    end

    it "answers organization path when kind is a string" do
      expect(path.index("orgs", "test").success).to eq("orgs/test/repos")
    end

    it "answers organization path when kind is a symbol" do
      expect(path.index(:orgs, "test").success).to eq("orgs/test/repos")
    end

    it "answers failure when kind is invalid" do
      expect(path.index("bogus", "test").failure).to eq(
        %(Invalid kind: "bogus". Use: "users" or "orgs".)
      )
    end
  end

  describe "#show" do
    it "answers path" do
      expect(path.show("demo", "test").success).to eq("repos/demo/test")
    end
  end

  describe "#create" do
    it "answers user path when kind is a symbol" do
      expect(path.create(:users).success).to eq("user/repos")
    end

    it "answers user path when kind is a string" do
      expect(path.create("users").success).to eq("user/repos")
    end

    it "answers organization path when kind is a symbol" do
      expect(path.create(:orgs, owner: "test").success).to eq("orgs/test/repos")
    end

    it "answers organization path when kind is a string" do
      expect(path.create("orgs", owner: "test").success).to eq("orgs/test/repos")
    end

    it "answers failure with missing organization" do
      expect(path.create(:orgs).failure).to eq("Organization name is missing.")
    end

    it "answers failure with invalid kind" do
      expect(path.create(:bogus).failure).to eq(%(Invalid kind: :bogus. Use: "users" or "orgs".))
    end
  end

  describe "#patch" do
    it "answers path" do
      expect(path.patch("demo", "test").success).to eq("repos/demo/test")
    end
  end

  describe "#destroy" do
    it "answers path" do
      expect(path.destroy("demo", "test").success).to eq("repos/demo/test")
    end
  end
end
