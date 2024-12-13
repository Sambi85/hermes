class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # POST /messages
  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to conversation_path(@message.conversation), notice: 'Message was successfully created.'
    else
      render :new
    end
  end
  
  # GET /messages/:id
  def show
  end
  
  private
  
  def set_message
    @message = Message.find(params[:id])
  end
  
  def message_params
    params.require(:message).permit(:user_id, :conversation_id, :body)
  end
end
