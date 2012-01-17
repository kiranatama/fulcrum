class ProjectsUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :project_id, :user_id, :role

  validates :user_id, :presence => true, :uniqueness => {:scope => :project_id}
end
