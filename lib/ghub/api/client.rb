# frozen_string_literal: true

require "dry/monads"

module Ghub
  module API
    # A low-level API client.
    class Client
      include Import[:configuration, :http]
      include Dry::Monads[:result]

      def initialize(page: Page, **)
        super(**)
        @page = page
      end

      def get path, **parameters
        return call __method__, path, params: parameters unless configuration.paginate

        page.of { |index| call __method__, path, params: parameters.merge(page: index) }
      end

      def post path, body = nil, **parameters
        call __method__, path, json: body, params: parameters
      end

      def put path, body = nil, **parameters
        call __method__, path, json: body, params: parameters
      end

      def patch path, body = nil, **parameters
        call __method__, path, json: body, params: parameters
      end

      def delete(path, **parameters) = call __method__, path, params: parameters

      private

      attr_reader :page

      def call method, path, **options
        http.auth("Bearer #{configuration.token}")
            .headers(accept: configuration.accept)
            .public_send(method, "#{configuration.url}/#{path}", options)
            .then { |response| response.status.success? ? Success(response) : Failure(response) }
      end
    end
  end
end
