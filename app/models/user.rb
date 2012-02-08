class User < ActiveRecord::Base

  # FIXME - DRY up, repeated in Story model
  JSON_ATTRIBUTES = ["id", "name", "initials", "email"]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :initials, :email_delivery, :email_acceptance, :email_rejection

  # Flag used to identify if the user was found or created from find_or_create
  attr_accessor :was_created

  has_many :projects_users
  has_many :projects, :through => :projects_users, :uniq => true

  validates :name, :presence => true
  validates :initials, :presence => true

  def to_s
    "#{name} (#{initials}) <#{email}>"
  end

  def as_json(options = {})
    super(:only => JSON_ATTRIBUTES)
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info

    if user = User.where(:email => data["email"]).first
      user
    else
      initials = data['first_name'][0] + data['last_name'][0]
      user = User.new(:initials => initials)
      user.name, user.email = data["name"], data["email"]
      user.save
      return nil unless user.valid?
      user
    end
  end

  def role_at(project)
    self.projects_users.where(:project_id => project).first.try(:role)
  end

  def password_required?
    false
  end
end
