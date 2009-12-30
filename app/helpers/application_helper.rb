# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	include TagsHelper
	
	# format_date
	def format_time(time)
	  DateTime.parse(time.to_s).strftime('%Y年%m月%d日 %H:%M:%S').to_s
	end
	
	def format_date(date)
	  DateTime.parse(date.to_s).strftime('%Y年%m月%d日').to_s
	end
	# 判断浏览器的类型,并且返回css
	def detect_brower
	  user_agent = request.env['HTTP_USER_AGENT'].downcase
	  if user_agent =~ /msie/i
	    stylesheet_link_tag 'blog_ie'
	  elsif user_agent =~ /gecko/i
	    stylesheet_link_tag 'blog_mozilla'
	  end
	end
	#def test
	  #stylesheet_link_tag 'blog_ie'
	#end
	# 返回最近的N篇文章
	def return_lately_article(num,&block)
	  @articles = Article.find(:all,:order => "created_at DESC",:limit => num)
	  for @article in @articles
	    yield
	  end
	end

	# 返回最近的N篇评论
	def return_lately_comment(num,&block)
	  @comments = Comment.find(:all,:order => "created_at DESC",:limit => num)
	  for @comment in @comments
	    yield
	  end
	end
	
	# 图片链接
	def image_link(linkpath,imagepath,options={})
	  concat "<a href='#{linkpath}' target=#{options.fetch(:target,'_blank')}><image src='#{imagepath}' border=#{options.fetch(:border,"0")}></a>"
	end
	
	# 字数控制
	def num_control(num)
	  
	end
end
