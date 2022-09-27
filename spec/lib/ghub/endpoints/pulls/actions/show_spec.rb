# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Actions::Show do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#call" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:repository/pulls/:id" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~JSON
              #{Bundler.root.join("spec/support/fixtures/pulls/show.json").read}
            JSON
          end
        end
      end

      it "answers pull request" do
        result = endpoint.call "bkuhlmann", "test", 1
        expect(result.success).to have_attributes(id: 211207854, number: 1)
      end
    end

    context "when empty" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:repository/pulls/:id" do
            headers["Content-Type"] = "application/json"
            status 200
            {}
          end
        end
      end

      it "answers errors" do
        result = endpoint.call "bkuhlmann", "bogus", 1
        expect(result.failure.errors.to_h).to include(id: ["is missing"])
      end
    end

    context "when not found" do
      let :http do
        HTTP::Fake::Client.new do
          get "/repos/:owner/:repository/pulls/:id" do
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

      it "answers error" do
        result = endpoint.call "bkuhlmann", "bogus", 1
        expect(result.failure.parse).to eq("message" => "Not Found")
      end
    end
  end
end
