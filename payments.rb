# frozen_string_literal: true

require 'active_support/all'
require 'pry'
require 'faraday'
require 'dotenv/load'

require_relative './boot'

require 'mpesa'

module Payments; end
