class Api::V1::MessagesController < ActionController::API
  before_action :set_message, only: [:show, :update, :destroy]
  before_action :validate_recipients, only: [:create]

  # GET /api/v1/conversations/:conversation_id/messages
  def index
    @conversation = Conversation.find(params['conversation_id'])
    @messages = @conversation.messages.order(created_at: :asc)  # Retrieve messages for the conversation
    render json: @messages, status: :ok
  end

  # POST /api/v1/messages
  def create
    @message = Message.new(message_params)

    if @message.save
      message_users = @recipients.map { |recipient| { message_id: @message.id, user_id: recipient.id } }
      MessageUser.insert_all(message_users)

      # send_sms_messages(@recipients, @message)

      ChatChannel.broadcast_to(
        @message.conversation,
        message: render_message(@message)
      )

      render json: { message: @message, recipients: @recipients }, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/messages/:id
  def show
    render json: @message, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Message not found" }, status: :not_found
  end

  # DELETE /api/v1/messages/:id
  def destroy
    if @message.destroy
      render json: { message: "Message deleted successfully" }, status: :no_content
    else
      render json: { error: "Unable to delete message" }, status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Message not found" }, status: :not_found
  end

  def message_params
    params.require(:message).permit(:user_id, :conversation_id, :body, recipient_ids: [])
  end

  def validate_recipients
    @recipients = User.where(id: params[:message][:recipient_ids])

    if @recipients.empty?
      render json: { error: "No valid recipients provided" }, status: :unprocessable_entity
    end
  end

  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/message', locals: { message: message }
    )
  end

  # def send_sms_messages(recipients, message)
  #   # Twilio integration (if applicable)
  # end
end
