require 'twilio-ruby'

class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'], 
      ENV['TWILIO_AUTH_TOKEN']
    )
    @redis = Redis.new
    @test_mode = ENV['RATE_LIMIT_TEST_MODE'] == 'true'
  end

  def send_message(from: ENV['TWILIO_PHONE_NUMBER'],to:, body:)
    begin

      if rate_limited?(to)
        raise 'Rate limit exceeded'
      end

      unless @test_mode
        # Only make the actual API call if we are not in test mode
        @client.messages.create(
          from: from,
          to: to,
          body: body
        )
      end

      record_sent_message(to)
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Error failed to send message: #{e.message}"
      raise
    end
  end

  def send_test_message
    # Use a valid phone number for testing.
    test_phone_number = ENV['TEST_PHONE_NUMBER']
    if test_phone_number.blank?
      Rails.logger.error "Test phone number is missing in environment variables."
      return
    end

    send_message(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: test_phone_number,
      body: 'TEST MESSAGE: This is a test message from your Twilio integration.'
    )
  end

  private

  def rate_limited?(phone_number)
    message_count = @redis.get("rate_limit:#{phone_number}").to_i
    message_count >= (ENV['RATE_LIMIT'] || 5).to_i
  end

  def record_sent_message(phone_number)
    key = "rate_limit:#{phone_number}"

    # Redis will automatically expire the key after the specified time
    @redis.multi do
      @redis.incr(key) #increment the count
      @redis.expire(key, (ENV['RATE_LIMIT_PERIOD'] || 3600).to_i) # Set to expire in 1 hour 
    end
  end

end