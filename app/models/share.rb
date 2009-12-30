class Share < ActiveRecord::Base
  # upload some stuffs
  has_attached_file :stuff,
                    :url => "/uploads/:attachment/:id/:style/:filename"           
                  
  validates_attachment_presence :stuff
end
