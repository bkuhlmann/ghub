# frozen_string_literal: true

module Ghub
  module Responses
    # Defines a set of links.
    Links = Dry::Schema.Params do
      required(:self).hash(Link)
      required(:html).hash(Link)
      required(:issue).hash(Link)
      required(:comments).hash(Link)
      required(:review_comments).hash(Link)
      required(:review_comment).hash(Link)
      required(:commits).hash(Link)
      required(:statuses).hash(Link)
    end
  end
end
