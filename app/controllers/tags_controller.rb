class TagsController < ApplicationController

	def create
    	@tag = Tag.new(tag_params)
    	@tag.save
    	redirect_to new_article_path
 	end

 	def show
 		@tag = Tag.find(params[:id])
 		@articles = @tag.articles.where(publish: true)
 	end

 	private
    	def tag_params
	  		params.require(:tag).permit(:name)
    	end
end
