class AddRoleToProjectsUsers < ActiveRecord::Migration
  def self.up
    add_column :projects_users, :id, :primary_key
    add_column :projects_users, :role, :string, :default => "member"
  end

  def self.down
    remove_column :projects_users, :id
    remove_column :projects_users, :role
  end
end
