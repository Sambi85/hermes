class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    Rails.logger.info "Fetched all Users, count: #{@users.count}"
  rescue => e
    Rails.logger.error "Error fetching all users: #{e.message}"
  end
  
  # GET /users/:id
  def show
    @conversations = @user.conversations
    @messages = @user.messages
    Rails.logger.info "Fetched user ID: #{@user.id}, username: #{@user.name}"
  rescue => e
    Rails.logger.error "Error fetching user ID: #{params[:id]}, message: #{e.message}"
    redirect_to users_url, alert: 'User not found'
  end
  
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      Rails.logger.info "Successfully created user ID: #{@user.id}, username: #{@user.name}"
      redirect_to @user, notice: 'User was successfully created.'
    else
      Rails.logger.warn "Failed to create user, message: #{@user.errors.full_messages.join(', ')}"
      render :new
    end
  rescue => e
    Rails.logger.error "Error creating user, message: #{e.message}"
    render :new
  end
  
  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      Rails.logger.info "Successfully updated user ID: #{@user.id}, username: #{@user.name}"
      redirect_to @user, notice: 'User was successfully updated.'
    else
      Rails.logger.warn "Failed to update user ID: #{@user.id}, message: #{@user.errors.full_messages.join(', ')}"
      render :edit
    end
  rescue => e
    Rails.logger.error "Error updating user ID: #{@user.id}, message: #{e.message}"
    render :edit
  end
  
  # DELETE /users/:id
  def destroy
    Rails.logger.info "Destroying user ID: #{@user.id}, username: #{@user.name}"
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  rescue => e
    Rails.logger.error "Error destroying user ID: #{@user.id}, message: #{e.message}"
    redirect_to users_url, alert: 'Failed to destroy user.'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User ID: #{params[:id]} not found, message: #{e.message}"
    redirect_to users_url, alert: 'User not found.'
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :phone_number)
  end
end
