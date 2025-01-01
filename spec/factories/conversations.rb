FactoryBot.define do
  factory :conversation do
    name { "Test Conversation" }

    after(:create) do |conversation|
      conversation.users << create(:user) if conversation.users.empty?
    end
  end
end
