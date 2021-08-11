require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "john", email: "john@example.com", 
                        password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "vegetable saute", description: "great vegetable sautee, add vegetable and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken saute", description: "great chicken dish")
    @recipe2.save

    @admin_user = Chef.create!(chefname: "john1", email: "john1@example.com",
      password: "password", password_confirmation: "password", admin: true)   
  end
  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "mashrur@example.com" }}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title' #error partial
    assert_select 'div.panel-body' #error partial
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "mashrur1", email: "mashrur1@example.com" }}
    assert_redirected_to @chef #chefs show page
    assert_not flash.empty?
    @chef.reload
    assert_match "mashrur1",  @chef.chefname
    assert_match "mashrur1@example.com", @chef.email
  end

  test "accept edit attempt by admin user " do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "mashrur3", email: "mashrur3@example.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "mashrur3",  @chef.chefname
    assert_match "mashrur3@example.com", @chef.email
  end

  test "redirect edit attempt by another admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email  } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "mashrur",  @chef.chefname
    assert_match "mashrur@example.com", @chef.email
  end
end
