FactoryBot.define do
  factory :application do
    name { FFaker::Company.name }
    token { SecureRandom.hex(24) }
  end
end
