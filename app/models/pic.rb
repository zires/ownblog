class Pic<ActiveRecord::Base
  belongs_to :category
  acts_as_fleximage :image_directory => 'public/pics'
  image_storage_format :jpg
  output_image_jpg_quality 100
  require_image true
  missing_image_message  'is required'
  invalid_image_message 'was not a readable image'
  default_image_path 'public/images/face.jpg'
  
  
end