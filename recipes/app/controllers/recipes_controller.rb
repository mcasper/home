class RecipesController < ApplicationController
  def index
    recipes = Recipe.all.preload(:category)
    grouped_recipes = recipes.group_by(&:category)
    render(:index, locals: { recipes_and_categories: grouped_recipes })
  end

  def new
    recipe = Recipe.new
    categories = Category.all
    render(:new, locals: { recipe: recipe, categories: categories })
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
    categories = Category.all
    render(:edit, locals: { recipe: recipe, categories: categories })
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
    params.require(:recipe).permit(:name, :url, :notes, :category_id)
  end
end
