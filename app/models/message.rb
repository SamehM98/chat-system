# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  message_number :integer
#  body           :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chat_id        :bigint
#
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :message_number, presence: true, uniqueness: { scope: :chat_id }

  belongs_to :chat


  delegate :application_token, to: :chat


  settings do
    mapping dynamic: false do
      indexes :body, type: :text, analyzer: 'english'
      indexes :chat_key, type: :text, analyzer: 'keyword'
    end
  end

def as_indexed_json(_options = nil)
    as_json(only: %i[body], methods: %i[chat_key])
  end

  def chat_key
    ChatHelpers.generate_key(application_token, chat.chat_number)
  end

  #this query is customized to partially match words, not exact match
  def self.search(query, key)
    self.__elasticsearch__.search({
                                    query: {
                                        bool: {
                                          "must": [
                                            { "wildcard": { body: "*#{query}*" }
                                            },
                                            { "term": { "chat_key.keyword": key } }
                                          ]
                                      }
                                    }
                                  }).records.to_a
  end

end
