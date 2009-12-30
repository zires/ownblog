module CommentsHelper
  # return the count of comments
  def find_amount_of_comments(article)
    Comment.count(:id, :conditions => ["commentable_id = ?",article.id])
  end
end
