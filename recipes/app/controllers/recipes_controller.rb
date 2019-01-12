class RecipesController < ApplicationController
  def index
    recipes = Recipe.all
    render(:index, locals: { recipes: recipes })
  end

  def new
    recipe = Recipe.new
    render(:new, locals: { recipe: recipe })
  end

  def create
    recipe = Recipe.new(recipe_params)

    if recipe.save
      flash[:info] = "Successfully saved recipe"
      redirect_to(recipes_path)
    else
      flash.now[:error] = "Failed to save recipe"
      render(:new, locals: { recipe: recipe })
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :url)
  end
end
