require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com",
                          password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "vegetable saute", description: "great vegetable sautee, add vegetable and oil", chef: @chef)
  end

  test "reject invalid recipe update" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe) #go to our edit path and it gets the recipe :id so we pass in the @recipe object 
    assert_template 'recipes/edit' #assert the template
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "some description"} } #update the recipe and post to recipe_path @recipe and params is what we are submitting, this should reject because the name is empty
    assert_template 'recipes/edit' #once it rejects be assert the template again
    assert_select 'h2.panel-title' #we assert the error partial
    assert_select 'div.panel-body' #we assert the error partial
  end

  test "successfully edit a recipe" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "updated recipe name"
    updated_description = "updated recipe description"
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe
    #follow_redirect!
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
