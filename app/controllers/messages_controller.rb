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
      
      MessageUser.insert_all(message_users) # Bulk Insert to guard against N + 1 queries

      ChatChannel.broadcast_to(
        @message.conversation,
        message: render_message(@message)
        )
        
      # send_sms_messages(recipients, @message)
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

  # GET /messages
  def index
    # @messages = @conversation.messages.order(created_at: :asc)  # Retrieve messages for the conversation
    # render json: @messages, status: :ok
  end


  def fetch_recipients(recipient_ids)
    puts "Recipient IDs: #{recipient_ids}"
    conversation = Conversation.find(params[:message][:conversation_id])

    User.where(id: recipient_ids).where(id: conversation.users.pluck(:id))
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

  # Render the message in the format that will be broadcast to clients
  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/message', locals: { message: message }
    )
  end
end
