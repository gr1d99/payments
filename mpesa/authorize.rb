# frozen_string_literal: true

module Payments
  class Mpesa
    class Authorize
      OATH_ENDPOINT = '/oauth/v1/generate'

      attr_reader :token, :expires_in

      def initialize
        @token = nil
        @expires_in = nil

        authorize unless toke_valid?
      end

      private

      attr_writer :token, :expires_in

      def connection
        Faraday.new(url: BASE_URL,
                    params: { grant_type: :client_credentials },
                    headers: { 'Content-Type' => 'application/json' }) do |conn|
          conn.request :authorization,
                       :basic,
                       ENV['MPESA_CONSUMER_KEY'],
                       ENV['MPESA_COSUMER_SECRET']
        end
      end

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
