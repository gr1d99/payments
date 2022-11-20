# frozen_string_literal: true

require_relative '../rspec_helper'

RSpec.describe 'Payments::Mpesa::Authorize' do
  subject { Payments::Mpesa::Authorize }

  context 'When not authorized' do
    it 'authorizes successfully' do
      instance = subject.new

      expect(instance.token).not_to be_nil
      expect(instance.expires_in).not_to be_nil
    end
  end
end
