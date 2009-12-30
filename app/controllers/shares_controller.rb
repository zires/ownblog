class SharesController < ApplicationController
  # new
  def new
    
  end
  #create/ post

  def show
    @share = Share.find(params[:id])
  end
  def create
    @share = Share.create(params[:share])
    respond_to do |wants|
      wants.html {  render :action => "show"}
    end
  end
end
