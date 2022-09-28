# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Protection::Root do
  using Infusible::Stub

  subject(:endpoint) { described_class.new }

  around { |example| Ghub::Import.stub_with(http:) { example.run } }

  describe "#show" do
    let :http do
      HTTP::Fake::Client.new do
        get "/repos/:owner/:repository/branches/:branch/protection" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            #{Bundler.root.join("spec/support/fixtures/branches/show.json").read}
          JSON
        end
      end
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#update" do
    let :http do
      HTTP::Fake::Client.new do
        put "/repos/:owner/:repository/branches/:branch/protection" do
          headers["Content-Type"] = "application/json"
          status 200
          Bundler.root.join("spec/support/fixtures/branches/show.json").read
        end
      end
    end

    it "answers success" do
      result = endpoint.update(
        "bkuhlmann",
        "test",
        "main",
        {
          enforce_admins: false,
          restrictions: nil,
          required_status_checks: {
            strict: false,
            contexts: ["ci/circleci: build"]
          },
          required_pull_request_reviews: nil,
          required_linear_history: true
        }
      )

      expect(result.success).to have_attributes(required_linear_history: {enabled: true})
    end
  end

  describe "#destroy" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:repository/branches/:branch/protection" do
            headers["Content-Type"] = "application/json"
            status 204
          end
        end
      end

      it "answers no content" do
        result = endpoint.destroy "bkuhlmann", "test", "main"
        expect(result.success.status.code).to eq(204)
      end
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:repository/branches/:branch/protection" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"message": "Not Found"}
            JSON
          end
        end
      end

      it "answers error" do
        result = endpoint.destroy "bkuhlmann", "test", "main"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
