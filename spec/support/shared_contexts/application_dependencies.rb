# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  let(:api) { Ghub::API::Client.new http: }
  let(:http) { class_double HTTP }

  before { Ghub::Container.stub! http:, api: }

  after { Ghub::Container.restore }
end
