# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Client do
  subject(:client) { described_class.new }

  describe "#initialize" do
    let(:configuration) { Ghub::Configuration::Content.new }

    before { Ghub::Container.stub! configuration: }

    after { Ghub::Container.restore }

    it "answers original configuration without block" do
      described_class.new

      expect(Ghub::Container[:configuration]).to have_attributes(
        accept: nil,
        paginate: nil,
        token: nil,
        url: nil
      )
    end

    it "modifies configuration with block" do
      described_class.new { |config| config.paginate = true }

      expect(Ghub::Container[:configuration]).to have_attributes(
        accept: nil,
        paginate: true,
        token: nil,
        url: nil
      )
    end
  end

  describe "#branch_protection" do
    it "answers endpoint" do
      expect(client.branch_protection).to be_a(Ghub::Endpoints::Branches::Protection::Root)
    end
  end

  describe "#branch_signature" do
    it "answers endpoint" do
      expect(client.branch_signature).to be_a(Ghub::Endpoints::Branches::Signature::Root)
    end
  end

  describe "#organization_members" do
    it "answers endpoint" do
      expect(client.organization_members).to be_a(Ghub::Endpoints::Organizations::Members::Root)
    end
  end

  describe "#pulls" do
    it "answers endpoint" do
      expect(client.pulls).to be_a(Ghub::Endpoints::Pulls::Root)
    end
  end

  describe "#repositories" do
    it "answers endpoint" do
      expect(client.repositories).to be_a(Ghub::Endpoints::Repositories::Root)
    end
  end

  describe "#search_users" do
    it "answers endpoint" do
      expect(client.search_users).to be_a(Ghub::Endpoints::Search::Users::Root)
    end
  end

  describe "#users" do
    it "answers endpoint" do
      expect(client.users).to be_a(Ghub::Endpoints::Users::Root)
    end
  end

  describe "#inspect" do
    it "answers request and reponse as classes" do
      expect(described_class.new.inspect).to include(
        "@branch_protection=Ghub::Endpoints::Branches::Protection::Root, " \
        "@branch_signature=Ghub::Endpoints::Branches::Signature::Root, " \
        "@organization_members=Ghub::Endpoints::Organizations::Members::Root, " \
        "@pulls=Ghub::Endpoints::Pulls::Root, " \
        "@repositories=Ghub::Endpoints::Repositories::Root, " \
        "@search_users=Ghub::Endpoints::Search::Users::Root, " \
        "@users=Ghub::Endpoints::Users::Root, "
      )
    end
  end
end
