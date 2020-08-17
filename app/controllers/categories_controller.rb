class CategoriesController < ApplicationController
	before_action :authenticate_admin!, except: [:show]
	before_action :authenticate_user!, only: [:show]
	
	def index
		#@categories = Category.order(name: :asc).all
		@categories = Category.order(name: :asc).paginate(:page => params[:page], :per_page => 8)
	end

	def show
		@category = Category.find(params[:id])
		@categories = Category.all
	end

	def new
		@category = Category.new
	end

	def create
		params[:category][:name] = params[:category][:name].downcase
		@category = Category.new(category_params)
    	@category.save
    	redirect_to categories_path
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		params[:category][:name] = params[:category][:name].downcase
		@category = Category.find(params[:id])
		@category.update(category_params)
		redirect_to categories_path
	end

	def destroy
		@category = Category.find(params[:id])
		@category.destroy
		redirect_to categories_path
	end

	private
	def category_params
		params.require(:category).permit(:name)
	end
end
