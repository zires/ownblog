class Category < ActiveRecord::Base
  # 分类名唯一
  validates_presence_of  :cgname

  has_many :articles, :foreign_key => "category_id"
  has_many :pics, :foreign_key => "pic_category_id"
end
