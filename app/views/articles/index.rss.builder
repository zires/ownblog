xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rss "version" => "2.0" do
  xml.channel do
    xml.title "Zeroath  --关注编程,网络,以及一些个人爱好的家伙."
    xml.description "个人博客,相册,视频."
    xml.link root_url
    
    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.article_content
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link article_url(article)
        xml.guid article_url(article)
      end
    end
  end
end