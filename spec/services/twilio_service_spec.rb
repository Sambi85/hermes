require 'rails_helper'

RSpec.describe TwilioService, type: :service do
  let(:twilio_service) { TwilioService.new }
  let(:test_phone_number) { ENV['TEST_PHONE_NUMBER'] }
  let(:phone_number) { '1234567890' }

  before do
    # Stub the Twilio API call to avoid sending real messages
    allow(twilio_service).to receive(:send_message).and_return(double('Message', sid: 'fake_sid'))
  end

  describe '#send_test_message' do
    context 'when the test phone number is set in the environment' do
      it 'sends a test message' do
        expect(twilio_service).to receive(:send_message).with(
          from: ENV['TWILIO_PHONE_NUMBER'],
          to: test_phone_number,
          body: 'TEST MESSAGE: This is a test message from your Twilio integration.'
        )

        twilio_service.send_test_message
      end
    end

    context 'when the test phone number is missing' do
      before do
        ENV['TEST_PHONE_NUMBER'] = nil
      end

      it 'does not send a message and logs an error' do
        expect(Rails.logger).to receive(:error).with("Test phone number is missing in environment variables.")

        twilio_service.send_test_message
      end
    end
  end
end
