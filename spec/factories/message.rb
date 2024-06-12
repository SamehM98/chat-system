FactoryBot.define do
  factory :message do
    chat
    message_number { FFaker::Number.number(digits: 4) }
    body { FFaker::Lorem.sentence }
  end
end
