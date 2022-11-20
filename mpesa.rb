# frozen_string_literal: true

require 'mpesa/connection'
require 'mpesa/express'
require 'mpesa/utils'

module Payments
  class Mpesa
    BASE_URL = ENV['MPESA_BASE_URL']
  end
end
