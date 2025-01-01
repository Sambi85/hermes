FactoryBot.define do
  factory :message do
    body { "Test message body" }

    association :user, factory: :user
    association :conversation, factory: :conversation

    transient do
      custom_user { nil }
      custom_conversation { nil }
      custom_recipients { [] }  
    end

    after(:build) do |message, evaluator|
      message.user = evaluator.custom_user if evaluator.custom_user
      message.conversation = evaluator.custom_conversation if evaluator.custom_conversation
      if evaluator.custom_recipients.any?
        message.recipients = evaluator.custom_recipients
      end
    end
  end
end
