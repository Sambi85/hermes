class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]
    
  # GET /conversations
  def index
    @conversations = Conversation.all
  end
  
  # GET /conversations/:id
  def show
    @messages = @conversation.messages
  end
  
  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to @conversation, notice: 'Conversation was successfully created.'
    else
      render :new
    end
  end
  
  # PATCH/PUT /conversations/:id
  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: 'Conversation was successfully updated.'
    else
      render :edit
    end
  end
  
  # DELETE /conversations/:id
  def destroy
    @conversation.destroy
    redirect_to conversations_url, notice: 'Conversation was successfully destroyed.'
  end
  
  private
  
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
  
  def conversation_params
    params.require(:conversation).permit(:name, user_ids: [])
  end
end
