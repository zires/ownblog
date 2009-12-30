module PicsHelper
  # 缩略图的链接
  def thumblink(linkpath,imagepath,options={})
    concat "<a href='#{linkpath}' class=#{options.fetch(:class)} title=#{options.fetch(:title)}><image src='#{imagepath}' alt=#{options.fetch(:alt)} width=#{options.fetch(:width)} height=#{options.fetch(:height)} ></a>"
  end
  
  
end