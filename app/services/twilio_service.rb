require 'twilio-ruby'

class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'], 
      ENV['TWILIO_AUTH_TOKEN']
      )
  end

  def send_message(from: ENV['TWILIO_PHONE_NUMBER'],to:, body:)
    begin
      @client.messages.create(
        from: from,
        to: to,
        body: body
      )
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

end