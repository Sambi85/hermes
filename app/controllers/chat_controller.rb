class ChatController < ApplicationController
  def show
    if ENV['ENABLE_CHAT_UI'] == 'true'
      @conversation = Conversation.find(params[:conversation_id])
      # render the full frontend chat UI
    else
      # return a basic message or debug info, or raise an error
      render json: { message: 'Chat UI is disabled for this environment' }
    end
  end
end
