module Payments
  module Mpesa
    module Connection
      class << self
        def initialize
          Faraday.new(url: BASE_URL,
                      params: { grant_type: :client_credentials },
                      headers: { 'Content-Type' => 'application/json' }) do |conn|
            conn.request :authorization,
                         :basic,
                         ENV['MPESA_CONSUMER_KEY'],
                         ENV['MPESA_COSUMER_SECRET']
          end
        end
      end
    end
  end
end