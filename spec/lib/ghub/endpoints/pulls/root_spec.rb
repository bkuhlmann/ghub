# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Endpoints::Pulls::Root do
  subject(:endpoint) { described_class.new index_action:, show_action: }

  include_context "with application dependencies"

  let(:index_action) { Ghub::Endpoints::Pulls::Actions::Index.new api: }
  let(:show_action) { Ghub::Endpoints::Pulls::Actions::Show.new api: }

  describe "#index" do
    let :http do
      HTTP::Fake::Client.new do
        get "/repos/:owner/:repository/pulls" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            #{SPEC_ROOT.join("support/fixtures/pulls/index.json").read}
          JSON
        end
      end
    end

    it "answers pull requests" do
      result = endpoint.index "bkuhlmann", "test"
      expect(result.success.last).to have_attributes(id: 211207854, number: 1)
    end
  end

  describe "#show" do
    let :http do
      HTTP::Fake::Client.new do
        get "/repos/:owner/:repository/pulls/:id" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            #{SPEC_ROOT.join("support/fixtures/pulls/show.json").read}
          JSON
        end
      end
    end

    it "answers pull request" do
      result = endpoint.show "bkuhlmann", "test", 1
      expect(result.success).to have_attributes(id: 211207854, number: 1)
    end
  end
end
