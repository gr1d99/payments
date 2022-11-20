# frozen_string_literal: true

module Payments
  class Mpesa
    module Connection
      OATH_ENDPOINT = '/oauth/v1/generate'
      DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze
      class << self
        def call
          @_connection ||= Faraday.new(
            url: BASE_URL,
            params: { grant_type: :client_credentials },
            headers: DEFAULT_HEADERS
          ) do |conn|
            conn.request :authorization, :basic, ENV['MPESA_CONSUMER_KEY'], ENV['MPESA_CONSUMER_SECRET']
          end

          @_response = @_connection.get(OATH_ENDPOINT)

          raise Payments::MpesaError, @_response.body unless @_response.success?

          response_body = HashWithIndifferentAccess.new(JSON.parse(@_response.body))

          Faraday.new(
            url: BASE_URL,
            headers: DEFAULT_HEADERS.merge(
              { Authorization: "Bearer #{response_body[:access_token]}" }
            )
          )
        end
      end
    end
  end
end
