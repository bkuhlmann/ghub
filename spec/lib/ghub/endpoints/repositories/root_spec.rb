# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Repositories::Root do
  subject :endpoint do
    described_class.new api:, create_action:, index_action:, patch_action:, show_action:
  end

  include_context "with application dependencies"

  let(:create_action) { Ghub::Endpoints::Repositories::Actions::Create.new api: }
  let(:index_action) { Ghub::Endpoints::Repositories::Actions::Index.new api: }
  let(:patch_action) { Ghub::Endpoints::Repositories::Actions::Patch.new api: }
  let(:show_action) { Ghub::Endpoints::Repositories::Actions::Show.new api: }

  describe "#index" do
    let :http do
      HTTP::Fake::Client.new do
        get "/users/:owner/repos" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            [#{SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read}]
          JSON
        end
      end
    end

    it "answers success" do
      result = endpoint.index "users", "bkuhlmann"
      expect(result.success.first).to have_attributes(id: 11889072, name: "archiver")
    end
  end

  describe "#show" do
    let :http do
      HTTP::Fake::Client.new do
        get "/repos/:owner/:id" do
          headers["Content-Type"] = "application/json"
          status 200
          SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read
        end
      end
    end

    it "answers success" do
      result = endpoint.show "bkuhlmann", "archiver"
      expect(result.success).to have_attributes(id: 11889072, name: "archiver")
    end
  end

  describe "#create" do
    let :http do
      HTTP::Fake::Client.new do
        post "/user/repos" do
          headers["Content-Type"] = "application/json"
          status 201
          SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
        end
      end
    end

    it "answers success" do
      result = endpoint.create(:users, {name: "ghub-test", private: true})
      expect(result.success).to have_attributes(name: "ghub-test", private: true)
    end
  end

  describe "#patch" do
    let :http do
      HTTP::Fake::Client.new do
        patch "/repos/:owner/:id" do
          headers["Content-Type"] = "application/json"
          status 200
          SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
        end
      end
    end

    it "answers success" do
      result = endpoint.patch("bkuhlmann", "ghub-test", {description: "For test only."})

      expect(result.success).to have_attributes(name: "ghub-test", description: "For test only.")
    end
  end

  describe "#destroy" do
    context "with success" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 204
          end
        end
      end

      it "answers no content" do
        result = endpoint.destroy "bkuhlmann", "ghub-test"
        expect(result.success.status.code).to eq(204)
      end
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          delete "/repos/:owner/:id" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"message": "Not Found"}
            JSON
          end
        end
      end

      it "answers error" do
        result = endpoint.destroy "bkuhlmann", "invalid-test"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
