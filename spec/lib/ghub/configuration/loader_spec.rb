# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Configuration::Loader do
  subject(:loader) { described_class.new }

  describe "#call" do
    it "answers default configuration content" do
      expect(loader.call).to eq(
        Ghub::Configuration::Content[
          accept: "application/vnd.github+json",
          paginate: false,
          token: ENV.fetch("GITHUB_API_TOKEN"),
          url: "https://api.github.com"
        ]
      )
    end

    it "answers custom configuration content" do
      loader = described_class.new environment: {
        "GITHUB_API_ACCEPT" => "application/json",
        "GITHUB_API_PAGINATE" => "true",
        "GITHUB_API_TOKEN" => "ghp_abc",
        "GITHUB_API_URL" => "https://api.gh.com"
      }

      expect(loader.call).to eq(
        Ghub::Configuration::Content[
          accept: "application/json",
          paginate: true,
          token: "ghp_abc",
          url: "https://api.gh.com"
        ]
      )
    end
  end
end
