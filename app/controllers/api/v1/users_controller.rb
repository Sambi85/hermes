# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < ActionController::API
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/v1/users
  def index
    @users = User.all
    render json: @users, status: :ok
  rescue => e
    Rails.logger.error "Error fetching all users: #{e.message}"
    render json: { error: "Error fetching users: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/users/:id
  def show
    render json: @user, status: :ok
  rescue => e
    Rails.logger.error "Error fetching user ID: #{params[:id]}, message: #{e.message}"
    render json: { error: "User not found" }, status: :not_found
  end

  # POST /api/v1/users
  def create
    binding.pry
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      Rails.logger.warn "Failed to create user: #{@user.errors.full_messages.join(', ')}"
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error creating user: #{e.message}"
    render json: { error: "Error creating user: #{e.message}" }, status: :internal_server_error
  end

  # PATCH/PUT /api/v1/users/:id
  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      Rails.logger.warn "Failed to update user ID: #{@user.id}, message: #{@user.errors.full_messages.join(', ')}"
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error updating user ID: #{@user.id}, message: #{e.message}"
    render json: { error: "Error updating user: #{e.message}" }, status: :internal_server_error
  end

  # DELETE /api/v1/users/:id
  def destroy
    @user.destroy
    render json: { message: 'User successfully deleted' }, status: :no_content
  rescue => e
    Rails.logger.error "Error destroying user ID: #{@user.id}, message: #{e.message}"
    render json: { error: "Failed to destroy user: #{e.message}" }, status: :internal_server_error
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User ID: #{params[:id]} not found, message: #{e.message}"
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end
end
