class Mailer < ActionMailer::Base
  def invitation(project, owner, user)
    @project = project
    @user = user

    mail :to => user.email, :from => owner.email,
      :subject => "[#{project.name}] You are invited to join #{project.name} project."
  end
end
