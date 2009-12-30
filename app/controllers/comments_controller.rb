class CommentsController < ApplicationController
	def index
		
	end
	def create
	  respond_to do |format|
	  #先判断是否为空
	  #if !(params[:title]).blank? && !(params[:comment]).blank?
	    @comment = Comment.new(params[:comment])
		  @article = Article.find(params[:article_id])
		if !(@comment.title).blank? && !(@comment.comment).blank?
		  @article.comments<<@comment
		  format.html
		  format.js {render :update do |page|
		    page.remove "#hidecomment"
				page.insert_html :bottom, "comments", :partial => 'comments/comments_list', :locals => {:comment => @comment}
				page.visual_effect :highlight, "comments", :duration => 3
				page.alert('评论成功！')
			end
			}
		  #else
		    #flash[:notice] = "名字和内容不能为空！"
		    #renderredirect_to(model_path(@model))
		    #format.js { render :update do |page|
		      #page.insert_html :top, "newcomment",
	   # }
	  end
  end
		#@comment = Comment.new(params[:comment])
		#@article = Article.find(params[:article_id])
		#@article.comments<<@comment
		#respond_to do |format|
			#format.html
			#format.js {render :update do |page|
				#page.insert_html :bottom, "comments", :partial => 'comments/comments_list', :locals => {:comment => @comment}
				#page.visual_effect :highlight, "comments", :duration => 5
				#page.alert('评论成功！')
			#end
			#}
		#end
	end
end