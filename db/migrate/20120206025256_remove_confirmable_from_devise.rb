class RemoveConfirmableFromDevise < ActiveRecord::Migration
  def self.up
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
  end

  def self.down
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_index :users, :confirmation_token,   :unique => true
  end
end
