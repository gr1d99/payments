# frozen_string_literal: true

require_relative '../rspec_helper'

RSpec.describe 'Payments::Mpesa::Express' do
  context 'When request body is valid' do
    subject { Payments::Mpesa::Express }
    it 'returns success' do
      # params = {
      #   BusinessShortCode: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
      #   Password: '',
      #   Timestamp: '',
      #   TransactionType: 'CustomerPayBillOnline',
      #   Amount: 1,
      #   PartyA: '254700000000',
      #   PartyB: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
      #   PhoneNumber: '254700000000',
      #   CallBackURL: '',
      #   AccountReference: "gr1d99-ke-#{SecureRandom.uuid}",
      #   TransactionDesc: 'sandbox-test'
      # }
      #
      # result = subject.call(params: params)

      # {MerchantRequestID, CheckoutRequestID, ws_CO_20112022124845696700000000, ResponseCode, ResponseDescription, CustomerMessage,}
    end
  end
end
