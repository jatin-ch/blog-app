class CommentsController < ApplicationController
	before_action :authenticate_user!

	def create
    	@article = Article.find(params[:article_id])
    	@comment = @article.comments.create(comment_params)
    	redirect_to article_path(@article)
 	end

 	def destroy
    	@article = Article.find(params[:article_id])
      @comment = @article.comments.find(params[:id])
      if @comment.user.id == current_user.id
        @comment.destroy
        redirect_to article_path(@article)
      else
        redirect_back fallback_location: articles_path
      end
  	end
 
  	private
    	def comment_params
        # byebug
	      	params[:comment][:user_id] = current_user.id
	  		params.require(:comment).permit(:id,:body,:user_id)
    	end
end
