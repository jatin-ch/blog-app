class Users::ArticlesController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'

	def index
		@articles = current_user.articles
  	end
  	def show
  		@article = current_user.articles.find(params[:id])
  	end
end
