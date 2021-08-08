require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com", password: "password")
  end
  
  test "invalid login is rejected" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { sessions: {email: " ", password: " "}} #if email and pw entered blank we expect this to happen...
    assert_template 'sessions/new' #show the template
    assert_not flash.empty? #after it fails we go to another route
    assert_select "a[href=?]", login_path #when user is not logged in check for login path to be present
    assert_select "a[href=?]", logout_path, count: 0 #this shouldn't be present
    get root_path #after we go to another route it shouldn't fail
    assert flash.empty?
  end

  test "valid login credentials accepted" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { sessions: { email: @chef.email, password: @chef.password } }
    assert_redirected_to @chef
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
    assert_select "a[href=?]", login_path, count: 0 #this shouldn't be present when user is logged in
    assert_select "a[href=?]", logout_path # when user logged in there is a logout, path to view chef show page, and edit profile
    assert_select "a[href=?]", chef_path(@chef)
    assert_select "a[href=?]", edit_chef_path(@chef)
  end
end
