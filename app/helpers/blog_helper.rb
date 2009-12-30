module BlogHelper
  # comment num
  def limitcomment(comment,num)
    if comment =~ /[^><]*(?=<)/
        c = comment.scan(/[^><]*(?=<)/).to_s
      else
        c =comment
    end
    if c.size <= num
        c
      else
        c = c[0,num]
    end
  end
  
  # 文章
  
end
