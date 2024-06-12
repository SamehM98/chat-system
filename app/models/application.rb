# == Schema Information
#
# Table name: applications
#
#  id         :bigint           not null, primary key
#  token      :string           not null
#  name       :string
#  chats_count :number
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#
class Application < ApplicationRecord
  has_secure_token :token
  validates :name, presence: true
  validates :token, presence: true, uniqueness: true
  has_many :chats, dependent: :destroy
end
