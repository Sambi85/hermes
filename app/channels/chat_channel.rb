class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])
    
    Rails.logger.debug "Subscribed to conversation: #{@conversation.id} by user: #{params[:user_id]}"

    user = User.find(params[:user_id])
    if @conversation.users.include?(user)
      stream_for @conversation
    else
      reject
    end
  end

  def unsubscribed
    # Optionally, handle any cleanup here (e.g., notify other users that this user has left)
  end

  def send_chat_message(data)
    recipient_ids = data['recipient_ids']
    if recipient_ids.blank?
      reject_invalid_message("Recipient is required")
      return
    end

    recipients = User.find(recipient_ids)

    all_recipients_are_valid = recipients.all? { |recipient| @conversation.users.include?(recipient) }
    unless all_recipients_are_valid
      reject_invalid_message("One or more recipients are not part of this conversation")
      return
    end

    message = @conversation.messages.create!(user: current_user, body: data['message'])
    message.recipients << recipients

    ActionCable.server.broadcast(
      "chat_#{@conversation.id}_channel", 
      message: render_message(message) 
    )

    Rails.logger.debug "Message sent: #{message.body}"
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end

  def reject_invalid_message(error_message)
    ActionCable.server.broadcast(
      "chat_#{@conversation.id}_channel",
      error: error_message
    )
  end
end