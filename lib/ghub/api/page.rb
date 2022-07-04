# frozen_string_literal: true

require "dry/monads"
require "json"
require "refinements/arrays"

module Ghub
  module API
    # Represents a page of an API response.
    class Page
      extend Dry::Monads[:result]

      using Refinements::Arrays

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

      def initialize response
        @response = response
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

      def navigation target
        links.find { |link| link.include? target.to_s }
             .then { |link| String(link)[/page=(?<page>\d+)/, :page].to_i }
      end

      def links = String(response.headers["Link"]).split ", "
    end
  end
end
