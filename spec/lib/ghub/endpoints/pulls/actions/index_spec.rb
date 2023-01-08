# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Actions::Index do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:repository/pulls" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              #{Bundler.root.join("spec/support/fixtures/pulls/index.json").read}
            JSON
          end
        end
      end

      it "answers pull request" do
        result = endpoint.call "bkuhlmann", "test", state: "all"
        expect(result.success.last).to have_attributes(id: 211207854, number: 1)
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:repository/pulls" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {
                "message": "Not Found"
              }
            JSON
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "test"
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
