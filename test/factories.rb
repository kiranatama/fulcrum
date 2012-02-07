Factory.define :user do |u|
  u.sequence(:name) {|n| "User #{n}"}
  u.sequence(:initials) {|n| "U#{n}"}
  u.sequence(:email) {|n| "user#{n}@kiranatama.com"}
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :project do |p|
  p.name 'Test Project'
end

Factory.define :projects_user do |pu|
  pu.association :user
  pu.association :project
end

Factory.define :story do |s|
  s.title 'Test story'
  s.association :requested_by, :factory => :user
  s.association :project
end

Factory.define :changeset do |c|
  c.association :story
  c.association :project
end

Factory.define :note do |n|
  n.note        'Test note'
  n.association :story
  n.association :user
end
