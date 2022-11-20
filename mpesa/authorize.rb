# frozen_string_literal: true

module Payments
  class Mpesa
    class Authorize
      OATH_ENDPOINT = '/oauth/v1/generate'

      attr_reader :token, :expires_in, :connection

      def initialize
        @token = nil
        @expires_in = nil
        @connection ||= Connection.new

        authorize unless toke_valid?
      end

      private

      attr_writer :token, :expires_in

      def authorize
        response = connection.get(OATH_ENDPOINT)

        return nil unless response.success?

        process_response response
      end

      def process_response(response)
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))

        @token = response_body[:access_token]
        expiry = response_body[:access_token]
        @expires_in = Time.now + expiry.to_i.seconds
      end

      def toke_valid?
        return false if @expires_in.nil?

        Time.now > expires_in
      end
    end
  end
end
