 require 'test_helper'
 require 'rails-controller-testing'

  class RecipesTest < ActionDispatch::IntegrationTest
    
  def setup
    @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com")
    @recipe = Recipe.create(name: "vegetable saute", description: "great vegetable sautee, add vegetable and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken saute", description: "great chicken dish")
    @recipe2.save
  end
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name #look for a link in the page and match to the path and text name variable
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get recipes show view" do
    get recipe_path(@recipe) #need to pass in recipe object whose URL you're going to
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
end
