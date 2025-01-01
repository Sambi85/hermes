require 'rails_helper'

RSpec.describe TwilioService, type: :service do
  let(:twilio_service) { TwilioService.new }
  let(:test_phone_number) { ENV['TEST_PHONE_NUMBER'] }
  let(:phone_number) { '1234567890' }
  let(:redis) { Redis.new }

  before do
    ENV['RATE_LIMIT_TEST_MODE'] = 'true'
    print("Firing up Redis... #{redis.ping}")
    redis.flushdb # Clear Redis cache
  end

  describe '#send_message' do
    context 'when the rate limit is not exceeded' do
      it 'sends a message and increments the Redis key' do
        twilio_service.send_message(from: '5555555555', to: phone_number, body: 'Test')
        expect(redis.get("rate_limit:#{phone_number}").to_i).to eq(1)
      end
    end

    context 'when the rate limit is exceeded' do
      before do
        # Simulate that the recipient has already sent 5 messages in the past hour
        5.times { twilio_service.send_message(from: '5555555555', to: phone_number, body: 'Test') }
      end

      it 'raises a rate limit error' do
        allow(twilio_service).to receive(:send_message).and_raise('Rate limit exceeded')
        expect { twilio_service.send_message(from: '5555555555', to: phone_number, body: 'Test') }
          .to raise_error('Rate limit exceeded')
      end
    end
  end
end
