# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  chat_number    :integer
#  application_id :bigint           not null
#  messages_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_chats_on_application_id  (application_id)
#
# Foreign Keys
#
#  fk_rails_...  (application_id => applications.id)
#
class Chat < ApplicationRecord
  validates :chat_number, presence: true, uniqueness: { scope: :application_id }

  belongs_to :application
  has_many :messages


  delegate :token, to: :application, prefix: true
  
  def self.find_by_token_and_number(app_token , number)
    Chat.joins(:application).where(applications: { token: app_token } , chat_number: number).first
  end
end
