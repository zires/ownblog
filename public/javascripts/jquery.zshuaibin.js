jQuery.noConflict();
jQuery(function($){
	$("#rss1").hover(
		function(){
			$(this).find("img").attr("src","../images/rss2.png");
		},
		function(){
			$(this).find("img").attr("src","../images/rss1.png");
		})
  });
  