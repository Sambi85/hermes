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
end