class RemoveRecoverableFromDevise < ActiveRecord::Migration
  def self.up
    remove_column :users, :reset_password_token
  end

  def self.down
    add_column :users, :reset_password_token, :string
    add_index :users, :reset_password_token, :unique => true
  end
end
