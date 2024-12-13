class TwilioCredentialsController < ApplicationController
  before_action :set_twilio_credential, only: [:show, :edit, :update, :destroy]

  def show
    @twilio_credential = TwilioCredential.first
  end  
end

