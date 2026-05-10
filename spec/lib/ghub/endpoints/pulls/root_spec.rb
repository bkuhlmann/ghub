# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Root do
  subject(:endpoint) { described_class.new index_action:, show_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Pulls::Actions::Index.new api: }
  let(:show_action) { Ghub::Endpoints::Pulls::Actions::Show.new api: }

  before { allow(http).to receive_messages(auth: http, headers: http) }

  describe "#index" do
    before do
      body = SPEC_ROOT.join("support/fixtures/pulls/index.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return response
    end

    it "answers pull requests" do
      result = endpoint.index "bkuhlmann", "test"
      expect(result.success.last).to have_attributes(id: 211207854, number: 1)
    end
  end

  describe "#show" do
    before do
      body = SPEC_ROOT.join("support/fixtures/pulls/show.json").read
      response = HTTP::Response.new headers: {content_type: "application/json"},
                                    body:,
                                    status: 200,
                                    version: 1.0

      allow(http).to receive(:get).and_return response
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", 1
      expect(result.success).to have_attributes(id: 211207854, number: 1)
    end
  end
end
