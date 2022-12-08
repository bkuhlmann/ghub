# frozen_string_literal: true

require "http"
require "spec_helper"

RSpec.describe Ghub::API::Page do
  include Dry::Monads[:result]

  subject(:page) { described_class.new first }

  let :single do
    HTTP::Response.new request: HTTP::Request.new(verb: :get, uri: "https://www.example.com"),
                       headers: {"Content-Type" => "application/json"},
                       body: {label: "Last"}.to_json,
                       status: 200,
                       version: "1.1"
  end

  let :first do
    HTTP::Response.new request: HTTP::Request.new(verb: :get, uri: "https://api.github.com"),
                       headers: {
                         "Content-Type" => "application/json",
                         "Link" => "<https://api.github.com/user/0/repos?page=2>; rel=\"next\", " \
                                   "<https://api.github.com/user/0/repos?page=10>; rel=\"last\""
                       },
                       body: [{label: "First"}].to_json,
                       status: 200,
                       version: "1.1"
  end

  let :last do
    HTTP::Response.new request: HTTP::Request.new(verb: :get, uri: "https://www.example.com"),
                       headers: {
                         "Content-Type" => "application/json",
                         "Link" => "<https://api.github.com/user/0/repos?page=9>; rel=\"prev\", " \
                                   "<https://api.github.com/user/0/repos?page=1>; rel=\"first\""
                       },
                       body: [{label: "Last"}].to_json,
                       status: 200,
                       version: "1.1"
  end

  describe ".of" do
    it "answers single item body when not paginated" do
      result = described_class.of { Success single }
      expect(result.success.parse).to eq([{"label" => "Last"}])
    end

    it "answers multi-item body when paginated" do
      request = instance_double Proc
      allow(request).to receive(:call).and_return(Success(first), Success(last))
      result = described_class.of { request.call }

      expect(result.success.parse).to eq([{"label" => "First"}, {"label" => "Last"}])
    end
  end

  describe "#next" do
    it "answers next page when link exists" do
      expect(page.next).to eq(2)
    end

    it "answers zero when link doesn't exists" do
      first["Link"] = nil
      expect(page.next).to eq(0)
    end

    it "answers zero when on last page" do
      page = described_class.new last
      expect(page.next).to eq(0)
    end
  end

  describe "#last?" do
    it "answers true when on last page" do
      page = described_class.new last
      expect(page.last?).to be(true)
    end

    it "answers true request header link doesn't exist" do
      first["Link"] = nil
      expect(page.last?).to be(true)
    end

    it "answers false when multiple pages exists" do
      expect(page.last?).to be(false)
    end
  end

  describe "#body" do
    it "answers parsed body" do
      expect(page.body).to eq([{"label" => "First"}])
    end
  end

  describe "#to_response" do
    it "answers original response when content is empty" do
      expect(page.to_response).to eq(first)
    end

    it "answers new response when content is not empty" do
      body = [{label: "Test"}]
      result = page.to_response body

      expect(result).to have_attributes(
        request: kind_of(HTTP::Request),
        headers: {
          "Content-Type" => "application/json",
          "Link" => "<https://api.github.com/user/0/repos?page=2>; rel=\"next\", " \
                    "<https://api.github.com/user/0/repos?page=10>; rel=\"last\""
        },
        body: body.to_json,
        status: HTTP::Response::Status.new(200),
        version: "1.1"
      )
    end
  end
end
