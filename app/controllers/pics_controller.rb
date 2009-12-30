class PicsController < ApplicationController
  before_filter :login_required, :only => [:edit,:new,:update,:create]
  # cache
  caches_page :show
  layout 'user'
  
  def index
    @picategories = Category.find(:all,:conditions =>["cateable_type = ?","Pic"])
    @category_id = @picategories.id
    @pic = Pic.find(:first,:conditions =>["pic_category_id = ?",@category_id])
    respond_to do |wants|
      wants.html { }
    end
  end
  
  # upload a new pic
  def create
    @pic = Pic.new(params[:pic])
    if @pic.save
      respond_to do |wants|
        wants.html { redirect_to pic_url(@pic) }
      end
    end
  end
  

  
  # show a pic
  def show
    @pic = Pic.find(params[:id])
    respond_to do |wants|
      wants.html {}
    end
  end
 
  # show一组pics
  def picategory
    @pics = Pic.find(:all,:conditions =>["pic_category_id = ?",params[:category_id]])
    respond_to  do |wants|
      wants.html { render :partial => "pics/index",:layout =>false}
    end
  end
  # new
  def new
    @pic = Pic.new
  end
  # thumb
  def thumb
    @pic = Pic.find(params[:id])
    render :inline => "@pic.operate{|image| image.resize '90x90'}", :type => :flexi
  end
  
  def bigger
    @pic = Pic.find(params[:id])
    render :inline => "@pic.operate{|image| image.resize '240x180'}", :type => :flexi
  end
  #太大的话要预处理
  def avatar
    @pic = Pic.find(params[:id])
    render :inline => "@pic.operate{|image| image.resize '500x600'}", :type => :flexi
  end
  # cache
  def expire_picture(picture)
    expire_page pic_path(picture, :format => :jpg) 
    expire_page thumb_pic_path(picture, :format => :jpg) 
    expire_page avatar_pic_path(picture, :format => :jpg) 
  end
end