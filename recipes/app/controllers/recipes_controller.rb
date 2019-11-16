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

  def show
    recipe = Recipe.find(params[:id])
    render(:show, locals: { recipe: recipe })
  end

  def edit
    recipe = Recipe.find(params[:id])
    render(:edit, locals: { recipe: recipe })
  end

  def update
    recipe = Recipe.find(params[:id])

    if recipe.update(recipe_params)
      flash[:info] = "Successfully updated recipe"
      redirect_to(recipe_path(recipe))
    else
      flash.now[:error] = "Failed to update recipe"
      render(:edit, locals: { recipe: recipe })
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])

    if recipe.destroy
      flash[:info] = "Successfully deleted recipe"
    else
      flash[:error] = "Failed to delete recipe"
    end

    redirect_to(recipes_path)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :url, :notes)
  end
end
