class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    if @conversation
      stream_for @conversation
    else
      reject # Reject the connection if the conversation doesn't exist
    end
  end

  def unsubscribed
    # Optionally, handle any cleanup here (e.g., notify other users that this user has left)
  end

  def send_message(data)
    if current_user
      message = @conversation.messages.create!(user: current_user, body: data['message'])
      # Broadcast the message body and username to the channel
      broadcast_to(@conversation, message: message.body, user: current_user.username)
    else
      reject
    end
  end

end
