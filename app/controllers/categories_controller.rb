class CategoriesController < ApplicationController
  def index
    #@categories = Category.includes(:item_groups).where('item_groups.sort >= 1').order('item_groups.sort') #nope
    #@categories = Category.all #.order("name ASC")
    categories = Category.includes(:item_groups).order('item_groups.sort') #yes, but don't want first category
    #@categories = categories.where.not(name: 'Category')
    #@categories = categories.where(name: helpers.org_categories)
    categories = Category.find_by(name: 'Product-Category').categories
    #categories2 = Category.find_by(name: 'Identifier-Group').identifier_groups
    @categories = categories + Category.find_by(name: 'Option-Group').categories + categories2
  end

  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
