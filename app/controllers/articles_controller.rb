class ArticlesController < ApplicationController
	before_action :authenticate_user!
	
	def index
		if !params[:category].blank? && !params[:query].blank?
			@category = Category.find(params[:category])
    		@articles = @category.articles.where('title LIKE ? AND publish = ?', "%#{params[:query]}%",true).order(id: :desc)
		elsif !params[:category].blank?
			@category = Category.find(params[:category])
			@articles = @category.articles.where(publish: true).order(id: :desc)
		elsif !params[:query].blank?
			@articles = Article.where('title LIKE ? AND publish = ?', "%#{params[:query]}%",true).order(id: :desc)
		else
			@articles = Article.where(publish: true).order(id: :desc)
		end

		@arts = @articles.includes(:likes).all.map{|art| [art.id, art.likes.size]}.sort_by{|k| k[1]}.reverse
		ids = @arts.map{|art| art[0] }
		@top_articles = Article.where(id: ids, publish: true).limit(7)								

		if @articles.length == 0
			@query = params[:query]
			render '404'
		end

  	end

	def show
    	@article = Article.find(params[:id]) 
    	if @article.publish != true
    		redirect_back fallback_location: articles_path
    	end
  	end

	def new
		@article = Article.new
		@categories = Category.all
	end

	def edit
  		@article = Article.find(params[:id])
  		@categories = Category.all
  		if @article.user_id != current_user.id
  			redirect_back fallback_location: articles_path
  		end
	end

	def create
		# params[:article][:tag_ids].delete("") 
	 	@article = current_user.articles.create(article_params)
		redirect_to @article
	end

	def update
		@article = Article.find(params[:id])

		if @article.user.id == current_user.id 	 
		  	if @article.update(article_params)
		    	redirect_to @article
		  	else
		    	render 'edit'
		  	end
		else
			redirect_back fallback_location: articles_path
		end  	
	end

	def destroy
  		@article = Article.find(params[:id])

  		if @article.user.id == current_user.id
  			@article.destroy
  			redirect_to articles_path
  		else
  			redirect_back fallback_location: articles_path
  		end  						
	end

	private
		def article_params
			params[:article][:category_id] = params[:category]
	    	params.require(:article).permit(:title, :text, :publish, :category_id, :tag_ids => [])
	    end
end
