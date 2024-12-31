class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]
    
  # GET /conversations
  def index
    @conversations = Conversation.all
    Rails.logger.info "Fetched #{@conversations.count} conversations"
  rescue => e
    Rails.logger.error "Error fetching all conversations: #{e.message}"
  end
  
  # GET /conversations/:id
  def show
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation.nil?
      flash[:alert] = "Conversation not found"
      redirect_to conversations_path # or any other path you'd like
      return
    end
  
    @current_user = OpenStruct.new(name: 'Test User Name') # Place holder for testing... 
    @current_user.reload
    @messages = @conversation.messages
  
    Rails.logger.info "Fetched #{@messages.count} messages for conversation #{@conversation.id}"
  rescue => e
    Rails.logger.error "Error fetching messages for conversation #{@conversation.id}: #{e.message}"
  end
  
  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      Rails.logger.info "Successfully created conversation ID: #{@conversation.id}"
      redirect_to @conversation, notice: 'Conversation was successfully created.'
    else
      Rails.logger.warn "Failed to create conversation: #{@conversation.errors.full_messages.join(', ')}"
      render :new
    end
  rescue => e
    Rails.logger.error "Error creating conversation: #{e.message}"
    render :new
  end
  
  # PATCH/PUT /conversations/:id
  def update
    if @conversation.update(conversation_params)
      Rails.logger.info "Successfully updated conversation ID: #{@conversation.id}"
      redirect_to @conversation, notice: 'Conversation was successfully updated.'
    else
      Rails.logger.warn "Failed to update conversation: #{@conversation.errors.full_messages.join(', ')}"
      render :edit
    end
  rescue => e
    Rails.logger.error "Error updating conversation: #{e.message}"
    render :edit
  end
  
  # DELETE /conversations/:id
  def destroy
    @conversation.destroy
    Rails.logger.info "Successfully destroyed conversation ID: #{@conversation.id}"
    redirect_to conversations_url, notice: 'Conversation was successfully destroyed.'
  rescue => e
    Rails.logger.error "Error destroying conversation: #{e.message}"
    redirect_to conversations_url, alert: 'Failed to destroy conversation.'
  end

  def debug_chat
    @messages = @conversation.messages  # debugging: show all messages in the conversation
  end
  
  private
  
  def set_conversation
    @conversation = Conversation.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Error finding conversation ID:#{params[:id]}, message: #{e.message}"
    redirect_to conversations_url, alert: 'Conversation not found.'
  end
  
  def conversation_params
    params.require(:conversation).permit(:name, user_ids: [])
  end
end
