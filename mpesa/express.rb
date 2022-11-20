# frozen_string_literal: true

module Payments
  class Mpesa
    class Express
      EXPRESS_ENDPOINT = '/mpesa/stkpush/v1/processrequest'

      def initialize(params)
        @timestamp = Utils.current_timestamp
        @connection = Connection.call
        @params = params
      end

      def self.call(params: {})
        new(params).initiate
      end

      def initiate
        _initiate
      end

      private

      attr_reader :params, :connection, :timestamp

      def _initiate
        response = connection.post(EXPRESS_ENDPOINT) do |request|
          request.body = with_other_params.to_json
        end

        raise Payments::MpesaError, response.body unless response.success?

        HashWithIndifferentAccess.new(JSON.parse(response.body))
      end

      def with_other_params
        @params.merge({ Password: password, Timestamp: timestamp })
      end

      def password
        short_code = ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE']
        pass_key = ENV['MPESA_EXPRESS_PASSKEY']
        Base64.strict_encode64("#{short_code}#{pass_key}#{timestamp}")
      end
    end
  end
end
