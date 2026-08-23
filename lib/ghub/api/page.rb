# frozen_string_literal: true

require "dry/monads"
require "json"
require "refinements/array"
require "rfc/web/link"

module Ghub
  module API
    # Represents a page of an API response.
    class Page
      include Dependencies[:configuration, :web_link]
      extend Dry::Monads[:result]

      using Refinements::Array

      def self.of index = 1, bodies: [], &request
        yield(index).fmap { |response| new response }
                    .fmap { |page| [page, bodies.including(page.body)] }
                    .bind do |page, amalgam|
                      if page.last?
                        Success page.to_response(amalgam)
                      else
                        of page.next, bodies: amalgam, &request
                      end
                    end
      end

      def initialize(response, **)
        @response = response
        super(**)
      end

      def next = navigation __method__

      def last? = navigation(:last).zero?

      def body = response.parse

      def to_response content = []
        return response if content.empty?

        response.class.new request: response.request,
                           headers: response.headers,
                           body: content.to_json,
                           status: response.status,
                           version: response.version
      end

      private

      attr_reader :response

      def navigation direction
        link = web_link.call(response.headers, root_uri: configuration.url).find do |link|
          link.find_pair(key: /rel/, value: /#{direction}/)
        end

        link ? link.uri[/page=(?<page>\d+)/, :page].to_i : 0
      end
    end
  end
end
