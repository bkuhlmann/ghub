# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ghub::Models::Links do
  subject(:model) { described_class.new }

  describe ".for" do
    let :body do
      Bundler.root
             .join("spec/support/fixtures/pulls/show.json")
             .read
             .then { |body| JSON body, symbolize_names: true }
             .then { |body| body.fetch :_links }
    end

    it "answers record" do
      expect(described_class.for(**body)).to have_attributes(
        self: Ghub::Models::Link[href: "https://api.github.com/repos/bkuhlmann/test/pulls/1"],
        html: Ghub::Models::Link[href: "https://github.com/bkuhlmann/test/pull/1"],
        issue: Ghub::Models::Link[href: "https://api.github.com/repos/bkuhlmann/test/issues/1"],
        comments: Ghub::Models::Link[
          href: "https://api.github.com/repos/bkuhlmann/test/issues/1/comments"
        ],
        review_comments: Ghub::Models::Link[
          href: "https://api.github.com/repos/bkuhlmann/test/pulls/1/comments"
        ],
        review_comment: Ghub::Models::Link[
          href: "https://api.github.com/repos/bkuhlmann/test/pulls/comments{/number}"
        ],
        commits: Ghub::Models::Link[
          href: "https://api.github.com/repos/bkuhlmann/test/pulls/1/commits"
        ],
        statuses: Ghub::Models::Link[
          href: "https://api.github.com/repos/bkuhlmann/test/statuses/e64bf3befe99f306e8c06cfd640d31e0549cdbf4"
        ]
      )
    end
  end

  describe "#initialize" do
    it_behaves_like "a model"
  end
end
