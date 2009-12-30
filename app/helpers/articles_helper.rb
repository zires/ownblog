module ArticlesHelper
	# article_title_link
	# read more
	def readmore(article)
		@num = 900
		if article.size <= @num
		    article
		  else
		    article = article[0,@num-1]
		end
	end
	
end
