class AddIndexToChats < ActiveRecord::Migration[7.1]
  def change
    add_index :chats, [:chat_number, :application_id]
  end
end
