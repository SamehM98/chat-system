FactoryBot.define do
  factory :chat do
    application
    chat_number { FFaker::Number.number(digits: 4) }
  end
end
