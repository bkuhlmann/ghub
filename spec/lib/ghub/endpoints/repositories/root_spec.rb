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

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    before do
      body = [JSON(SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read)].to_json
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return response
    end

    it "answers success" do
      result = endpoint.index "users", "bkuhlmann"
      expect(result.success.first).to have_attributes(id: 11889072, name: "archiver")
    end
  end

  describe "#show" do
    before do
      body = SPEC_ROOT.join("support/fixtures/repositories/show-user.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return response
    end

    it "answers success" do
      result = endpoint.show "bkuhlmann", "archiver"
      expect(result.success).to have_attributes(id: 11889072, name: "archiver")
    end
  end

  describe "#create" do
    before do
      body = SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 201,
                                    version: 1.0

      allow(http).to receive(:post).and_return response
    end

    it "answers success" do
      result = endpoint.create(:users, {name: "ghub-test", private: true})
      expect(result.success).to have_attributes(name: "ghub-test", private: true)
    end
  end

  describe "#patch" do
    before do
      body = SPEC_ROOT.join("support/fixtures/repositories/create_or_patch.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:patch).and_return response
    end

    it "answers success" do
      result = endpoint.patch("bkuhlmann", "ghub-test", {description: "For test only."})

      expect(result.success).to have_attributes(name: "ghub-test", description: "For test only.")
    end
  end

  describe "#destroy" do
    context "with success" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {}.to_json,
                                      status: 204,
                                      version: 1.0

        allow(http).to receive(:delete).and_return response
      end

      it "answers no content" do
        result = endpoint.destroy "bkuhlmann", "ghub-test"
        expect(result.success.status.code).to eq(204)
      end
    end

    context "with failure" do
      before do
        response = HTTP::Response.new headers: {content_type: "application/json"},
                                      body: {message: "Not Found"}.to_json,
                                      status: 404,
                                      version: 1.0

        allow(http).to receive(:delete).and_return response
      end

      it "answers error" do
        result = endpoint.destroy "bkuhlmann", "invalid-test"
        expect(result.failure.parse).to include("message" => "Not Found")
      end
    end
  end
end
