class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      Rails.logger.info "Successfully created message ID: #{@message.id}"

      recipients = fetch_recipients(params[:recipient_ids])
      if recipients.empty?
        render :new and return
      end

      @message.recipients << recipients
      message_users = recipients.map { |recipient| { message_id: @message.id, user_id: recipient.id } }
      
      #Bulk Insert to guard againist N + 1
      MessageUser.insert_all(message_users)

      send_sms_messages(recipients, @message)
      
      redirect_to conversation_path(@message.conversation), notice: 'Message was successfully created.'
    else
      Rails.logger.warn "Failed to create message: #{@message.errors.full_messages.join(', ')}"
      render :new
    end
  rescue => e
    Rails.logger.error "Error creating message: #{e.message}"
    render :new
  end
  
  # GET /messages/:id
  def show
    Rails.logger.info "Fetched message ID: #{@message.id}"
  rescue => e
    Rails.logger.error "Error fetching message ID: #{params[:id]}, message: #{e.message}"
    redirect_to conversations_path, alert: 'Message not found.'
  end

  def fetch_recipients(recipient_ids)
    # May need to shape this data further for forms...
    User.where(id: recipient_ids)
  end

  def send_sms_messages(recipients, message)
    twilio_service = TwilioService.new
    recipients.each do |recipient|
      twilio_service.send_message(
        from: message.user.phone_number,
        to: recipient.phone_number,
        body: message.body
      )
    end
  end


  
  private
  
  def set_message
    @message = Message.find(params[:id])

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Message ID: #{params[:id]} not found, message: #{e.message}"
    redirect_to conversations_url, alert: 'Message not found.'
  end
  
  def message_params
    params.require(:message).permit(:user_id, :conversation_id, :body, recipient_ids: [])
  end
end
