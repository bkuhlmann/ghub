# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Branches::Signature::Root do
  subject(:endpoint) { described_class.new api: }

  include_context "with application dependencies"

  describe "#show" do
    let :http do
      HTTP::Fake::Client.new do
        get "/repos/:owner/:repository_id/branches/:id/protection/required_signatures" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            {
              "url": "https://api.github.com/repos/bkuhlmann/test/branches/main/protection/required_signatures",
              "enabled": true
            }
          JSON
        end
      end
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#create" do
    let :http do
      HTTP::Fake::Client.new do
        post "/repos/:owner/:repository_id/branches/:id/protection/required_signatures" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            {
              "url": "https://api.github.com/repos/bkuhlmann/test/branches/main/protection/required_signatures",
              "enabled": true
            }
          JSON
        end
      end
    end

    it "answers pull request" do
      result = endpoint.create "bkuhlmann", "test", "main"
      expect(result.success).to have_attributes(url: kind_of(String))
    end
  end

  describe "#destroy" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:repository_id/branches/:id/protection/required_signatures" do
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
          delete "/repos/:owner/:repository_id/branches/:id/protection/required_signatures" do
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
