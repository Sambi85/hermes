# app/controllers/api/v1/conversations_controller.rb
class Api::V1::ConversationsController < ActionController::API
  before_action :set_conversation, only: [:show, :update, :destroy, :index]


  # GET /api/v1/conversations
  def index
    binding.pry
    @conversations = Conversation.all
    render json: @conversations, status: :ok
  rescue => e
    Rails.logger.error "Error fetching all conversations: #{e.message}"
    render json: { error: "Error fetching conversations: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/conversations/:id
  def show
    @messages = @conversation.messages
    render json: { conversation: @conversation, messages: @messages }, status: :ok
  rescue => e
    Rails.logger.error "Error fetching conversation ID: #{@conversation.id}, message: #{e.message}"
    render json: { error: "Conversation not found" }, status: :not_found
  end

  # POST /api/v1/conversations
  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      render json: @conversation, status: :created
    else
      Rails.logger.warn "Failed to create conversation: #{@conversation.errors.full_messages.join(', ')}"
      render json: { errors: @conversation.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error creating conversation: #{e.message}"
    render json: { error: "Error creating conversation: #{e.message}" }, status: :internal_server_error
  end

  # PATCH/PUT /api/v1/conversations/:id
  def update
    if @conversation.update(conversation_params)
      render json: @conversation, status: :ok
    else
      Rails.logger.warn "Failed to update conversation ID: #{@conversation.id}, message: #{@conversation.errors.full_messages.join(', ')}"
      render json: { errors: @conversation.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error updating conversation ID: #{@conversation.id}, message: #{e.message}"
    render json: { error: "Error updating conversation" }, status: :internal_server_error
  end

  # DELETE /api/v1/conversations/:id
  def destroy
    @conversation.destroy
    render json: { message: 'Conversation successfully deleted' }, status: :no_content
  rescue => e
    Rails.logger.error "Error destroying conversation ID: #{@conversation.id}, message: #{e.message}"
    render json: { error: "Failed to destroy conversation" }, status: :internal_server_error
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Error finding conversation ID:#{params[:id]}, message: #{e.message}"
    render json: { error: "Conversation not found" }, status: :not_found
  end

  def conversation_params
    params.require(:conversation).permit(:name, user_ids: [])
  end
end