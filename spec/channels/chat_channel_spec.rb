require 'rails_helper'
require 'chat_channel'

RSpec.describe ChatChannel, type: :channel do
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation) }

  before do
    conversation.users << user
    stub_connection params: { user_id: user.id, conversation_id: conversation.id } # Simulate passing user_id in the connection params
  end

  describe 'subscribing to the chat channel' do
    it 'successfully subscribes the user to the conversation channel' do

      subscribe(conversation_id: conversation.id, user_id: user.id)

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(conversation)
    end
  end
end
