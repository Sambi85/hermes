class ChatController < ApplicationController
  def show
    @room = Conversation.find(params[:conversation_id])
  end
end