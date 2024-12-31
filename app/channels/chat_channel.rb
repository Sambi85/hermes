class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    stream_for @conversation
  end

  def unsubscribed
    # Optionally, handle any cleanup here (e.g., notify other users that this user has left)
  end

  def send_message(data)
    message = @conversation.messages.create!(user: current_user, content: data['message'])

    ActionCable.server.broadcast("chat_#{@conversation.id}_channel", message: message.content, user: current_user.username)
  end
end
