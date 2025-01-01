class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find_by(id: params[:conversation_id])

    if @conversation
      stream_for @conversation
    else
      reject_unauthorized_connection
    end
  end

  def unsubscribed
    # Optionally handle cleanup when the user unsubscribes from the channel.
  end

  def send_message(data)
    if current_user
      message = @conversation.messages.create!(user: current_user, body: data['message'])
      
      broadcast_to(@conversation, message: message.body, user: current_user.name)
    else
      reject
    end
  end
end
