module ChatHelpers
  def self.generate_key(token, chat_number)
    "CHAT-#{token}-#{chat_number}"
  end
end
