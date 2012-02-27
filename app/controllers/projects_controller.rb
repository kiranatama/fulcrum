class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_filter :prepare_projects, :except => [:new]

  # GET /projects
  # GET /projects.xml
  def index
    @projects = @projects.all if current_user.admin?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = @projects.find(params[:id])
    @story = @project.stories.build

    respond_to do |format|
      format.html # show.html.erb
      format.js   { render :json => @project }
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @projects.find(params[:id])
    @project.users.build
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = @projects.build(params[:project])

    # User who create a project is automatically assigned as owner
    @project.projects_users.build(:user_id => current_user.id, :role => "owner")

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = @projects.readonly(false).find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = @projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  # GET /projects/1/users
  # GET /projects/1/users.xml
  def users
    @project = @projects.find(params[:id])
    @users = @project.users

    respond_to do |format|
      format.html # users.html.erb
      format.xml  { render :xml => @project }
    end
  end

  protected

  def prepare_projects
    @projects = current_user.admin? ? Project : current_user.projects
  end
end
