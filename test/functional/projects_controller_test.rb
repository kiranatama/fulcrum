require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  setup do
    @project = Factory.create(:project)
    @user = Factory.create(:user)
    @assignment = Factory.create(:projects_user, :project => @project, :user => @user, :role => "owner")
  end

  test "should not get project list if not logged in" do
    get :index
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
    other_project = Factory.create(:project)
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
    assert assigns(:projects).include?(@project)

    # Ensure the user cannot see other users projects
    assert !assigns(:projects).include?(other_project)
  end

  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create project" do
    sign_in @user
    assert_difference('Project.count') do
      post :create, :project => @project.attributes
      assert_equal [@user], assigns(:project).users
      assert_equal @user.role_at(assigns(:project).id), "owner"
      assert_redirected_to project_path(assigns(:project))
    end
  end

  test "should show project" do
    sign_in @user
    get :show, :id => @project.to_param
    assert_equal @project, assigns(:project)
    assert assigns(:story)
    assert_response :success
  end

  test "should show project in js format" do
    sign_in @user
    get :show, :id => @project.to_param, :format => 'js'
    assert_equal @project, assigns(:project)
    assert_response :success
  end

  test "should not show other users project" do
    other_user = Factory.create(:user)
    sign_in other_user
    get :show, :id => @project.to_param
    assert_response 403
  end

  test "should get edit" do
    sign_in @user
    get :edit, :id => @project.to_param
    assert_response :success
  end

  test "should not edit other users project" do
    other_user = Factory.create(:user)
    sign_in other_user
    get :edit, :id => @project.to_param
    assert_response 403
  end

  test "should not edit project as member" do
    other_member = Factory.create(:user)
    assignment = Factory.create(:projects_user, :project => @project, :user => other_member, :role => "member")
    sign_in other_member
    get :edit, :id => @project.to_param
    assert_response 403
  end

  test "should update project" do
    sign_in @user
    put :update, :id => @project.to_param, :project => @project.attributes
    assert_redirected_to project_path(assigns(:project))
  end

  test "should not update other users project" do
    other_user = Factory.create(:user)
    sign_in other_user
    put :update, :id => @project.to_param, :project => @project.attributes
    assert_response 403
  end

  test "should not update project as member" do
    other_member = Factory.create(:user)
    assignment = Factory.create(:projects_user, :project => @project, :user => other_member, :role => "member")
    sign_in other_member
    put :update, :id => @project.to_param, :project => @project.attributes
    assert_response 403
  end


  test "should show update errors" do
    sign_in @user
    attributes = Factory.attributes_for(:project)
    attributes[:name] = ''
    put :update, :id => @project.to_param, :project => attributes
    assert_response :success
  end

  test "should destroy project" do
    sign_in @user
    assert_difference('Project.count', -1) do
      delete :destroy, :id => @project.to_param
    end

    assert_redirected_to projects_path
  end

  test "should not destroy project as member" do
    other_member = Factory.create(:user)
    assignment = Factory.create(:projects_user, :project => @project, :user => other_member, :role => "member")
    sign_in other_member
    assert_difference('Project.count', 0) do
      delete :destroy, :id => @project.to_param
    end
    assert_response 403
  end

end
