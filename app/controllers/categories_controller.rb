class CategoriesController < ApplicationController
	layout 'category'
	
	def new	
	end
	
	def create
		@category =Category.new(params[:category])
		@category.save
	end
	
	# GET /categories/id
	def show
		# find out all articles belong to a category
		@articles = Article.find(:all, :conditions => ["category_id = ?",params[:id]], :order => "created_at DESC")
		respond_to do |wants|
			wants.html {  }
		end
	end
end
