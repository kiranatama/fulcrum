require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
    @project = Factory.create(:project)
    Factory.create(:projects_user, :project => @project, :user => @user, :role => "owner")

    request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "should change own initials" do
    sign_in @user
    put :update, :id => @user.to_param, :user => {:initials => "UU"}
    assert_equal @user, assigns(:user)
    assert_equal "UU", assigns(:user).initials
    assert_equal "You updated your account successfully.", flash[:notice]
    assert_redirected_to root_path
  end

  test "should not change name and email" do
    sign_in @user

    put :update, :id => @user.to_param, :user => {:name => "Updated User",
      :email => "updated.user@kiranatama.com"}
    assert_equal @user, assigns(:user)
    assert_not_equal "Updated User", assigns(:user).name
    assert_not_equal "updated.user@kiranatama.com", assigns(:user).email
    assert_response :redirect
  end
end
