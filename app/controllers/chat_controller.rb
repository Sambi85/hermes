# app/controllers/chat_controller.rb
class ChatController < ApplicationController
  def show
    @room = Room.find(params[:id])
  end
end
