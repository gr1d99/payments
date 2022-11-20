# frozen_string_literal: true

module Payments
  class Mpesa
    module Utils
      class << self
        def current_timestamp
          Time.now.strftime '%Y%m%d%H%M%S'
        end
      end
    end
  end
end
