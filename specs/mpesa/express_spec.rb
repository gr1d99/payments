# frozen_string_literal: true

require_relative '../rspec_helper'

RSpec.describe Payments::Mpesa::Express do
  subject { Payments::Mpesa::Express }

  before do
    allow(Payments::Mpesa::Utils).to receive(:current_timestamp) { '1234' }
    allow_any_instance_of(subject).to receive(:password) { '1234' }

    stub_request(:get, 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials')
      .with(
        basic_auth: [ENV['MPESA_CONSUMER_KEY'], ENV['MPESA_CONSUMER_SECRET']])
      .to_return(body: { access_token: '1234.5667', expires_in: 3599 }.to_json)
  end

  context 'When request body is valid' do
    let(:params) do
      {
        BusinessShortCode: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
        Password: '1234',
        Timestamp: '1234',
        TransactionType: 'CustomerPayBillOnline',
        Amount: 1,
        PartyA: '254700000000',
        PartyB: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
        PhoneNumber: '254700000000',
        CallBackURL: '',
        AccountReference: "1234",
        TransactionDesc: 'sandbox-test'
      }
    end

    let(:response_body) { { ResponseCode: '0' } }

    it 'initiates request' do
      stub_request(:post, 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest')
        .with(
          body: params.to_json,
          headers: {
            Authorization: 'Bearer 1234.5667'
          }
        ).to_return(status: 200, body: response_body.to_json, headers: {})

      response = subject.call(params: params)

      expect(
        a_request(:post, 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest')
          .with(body: params.to_json, headers: { Authorization: 'Bearer 1234.5667' })
      ).to have_been_made.once

      expect(response[:ResponseCode]).to eql '0'
    end
  end

  context 'When params are invalid' do
    let(:params) do
      {
        BusinessShortCode: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
        Password: '1234',
        Timestamp: '1234',
        TransactionType: 'CustomerPayBillOnline',
        Amount: 1,
        PartyA: '254700000000',
        PartyB: ENV['MPESA_EXPRESS_BUSINESS_SHORT_CODE'],
        PhoneNumber: '',
        CallBackURL: '',
        AccountReference: "1234",
        TransactionDesc: 'sandbox-test'
      }
    end

    it 'raises Payments::MpesaError' do
      stub_request(:post, 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest')
        .with(
          body: params.to_json,
          headers: {
            Authorization: 'Bearer 1234.5667'
          }
        ).to_return(status: 400, body: { errorMessage: 'Bad Request - Invalid PhoneNumber' }.to_json, headers: {})

      expect do
        subject.call(params: params)
      end.to raise_error Payments::MpesaError, { errorMessage: 'Bad Request - Invalid PhoneNumber' }.to_json
    end
  end
end
