require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com", password: "password")
  end
  
  test "invalid login is rejected" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: " ", password: " "}} #if email and pw entered blank we expect this to happen...
    assert_template 'sessions/new' #show the template
    assert_not flash.empty? #after it fails we go to another route
    get root_path #after we go to another route it shouldn't fail
    assert flash.empty?
  end

  test "valid login credentials accepted" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @chef.email, password: @chef.password } }
    assert_redirected_to @chef
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end
end
