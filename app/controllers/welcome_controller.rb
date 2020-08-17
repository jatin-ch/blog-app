class WelcomeController < ApplicationController
   respond_to :js, :json, :html

  def search_article
    if !params[:c].blank? && !params[:q].blank?
      @category = Category.find(params[:c]);
      @articles = @category.articles.where('title LIKE ? AND publish = ?', "%#{params[:q]}%",true)
    elsif !params[:q].blank?
      @articles = Article.where('title LIKE ? AND publish = ?', "%#{params[:q]}%",true)
    end

    respond_to do |format|
      format.js {render 'layouts/search_result'}
    end
  end

  def search
    if params[:search_term]
      @categories = Category.where('name LIKE ?', "%#{params[:search_term]}%")
      # p @categories
      respond_to do |format|
        # format.html {render 'categories/show'}
        format.js {render 'categories/show'}
      end
      #render 'categories/show'
    end
  end
	
  def filter
  	if params[:ids]
      @categories = Category.where(id: params[:ids])
      @articles = Article.where(category_id: @categories, publish: true)
	  else
		  @articles = Article.where(publish: true)
     end
     #p @articles.count 
     render 'articles/index'
  end

  def sort_by
    if !params[:sort_by_date].blank?
      @articles = Article.where(created_at: Date.strptime(params[:sort_by_date], '%Y-%m-%d').all_day)
    elsif !params[:sort_by_view].blank?
      @articles_hash = Article.includes(:likes).all.map{|article| [article.id, article.likes.size]}.sort_by{|k| k[1]}.reverse
      ids = @articles_hash.map{|article| article[0] }
      @articles = Article.where(id: ids, publish: true) 
    elsif !params[:sort_by_new].blank?
      @articles =  Article.where(publish: true).order(id: :desc) 
    else
      @articles = Article.where(publish: true)  
    end
    respond_to do |format|
      format.js {render 'articles/index'}
    end
  end

  def index
  end

  def like
    article = Article.find(params[:id])
    like = Like.where(likeable_id: params[:id], user_id: current_user.id)
    if like.count > 0
      like.first.destroy
      result = { 'islike' => false, 'likecount' => article.likes.count }
    else
      like = Like.create(user_id: current_user.id, likeable: article)  #likeable_type: 'Article', likeable_id: params[:id]
      result = { 'islike' => true, 'likecount' => article.likes.count }
    end
    respond_to do |format|
      format.js {render json: result}
    end
  end

end
