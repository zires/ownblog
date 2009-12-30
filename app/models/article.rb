class Article < ActiveRecord::Base
  # validates
  validates_presence_of  :title, :article_content
  validates_length_of  :title, :maximum => 60
	
  # notes or words
  #attr_accessible :aflag, :title, :article_content
  
  belongs_to :category, :foreign_key => "category_id"
  
  # use tag
  acts_as_taggable
  # use comment
  acts_as_commentable
  # upload stuffs
  #has_attached_file :photo
  #has_attached_file :stuff
  #validates_attachment_content_type :stuff, :content_type => ['image/pjpeg', 'image/x-png']
  #upload_column :stuff_file_name 
  
  													
	def get_category_id(category_id)
		self.category_id = category_id
	end
	
	# 分页
end
