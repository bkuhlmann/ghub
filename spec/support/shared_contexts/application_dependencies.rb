# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  let(:api) { Ghub::API::Client.new http: }

  before do
    Ghub::Container.test!
    Ghub::Container.stub http:, api:
  end

  after { Ghub::Container.restore }
end
