class UsersController < ApplicationController
  before_filter :prepare_project
  respond_to :html, :json

  def index
    @users = @project.users
    @user = User.new
    respond_with(@users)
  end

  def create
    @users = @project.users
    @user = User.find_or_create_by_email(params[:user][:email]) do |u|
      # Set to true if the user was not found
      u.was_created = true
      u.name = params[:user][:name]
      u.initials = params[:user][:initials]
    end

    if @user.new_record? && !@user.save
      render 'index'
      return
    end

    if @project.users.include?(@user)
      flash[:alert] = "#{@user.email} is already a member of this project"
    else
      @project.projects_users.create(:user_id => @user.id, :role => "member")
      mailer = Mailer.invitation(@project, current_user, @user)
      mailer.deliver if mailer

      if @user.was_created
        flash[:notice] = "#{@user.email} was sent an invite to join this project"
      else
        flash[:notice] = "#{@user.email} was added to this project"
      end
    end

    redirect_to project_users_url(@project)
  end

  def destroy
    @user = @project.users.find(params[:id])
    @project.users.delete(@user)
    redirect_to project_users_url(@project)
  end

  protected

  def prepare_project
    @project = (current_user.admin? ? Project : current_user.projects).find(params[:project_id])
  end
end
