class BlogController < ApplicationController
  # index
  def index
  	@categories = Category.all
    #@tags = Article.tag_counts
    @articles = Article.paginate(:per_page =>10,:page =>params[:page],:order => "created_at DESC")
    @page_info = @articles.total_pages
  end

  def show
  end
  
  def tag_cloud
  	@tags = Article.tag_counts
  end
  
  def about
    render :partial => "about",:layout => 'blog'
  end
  
  def video
    render :partial => "video",:layout => 'blog'
  end
  
  def share
    render :partial => "share",:layout => 'blog'
  end
end
