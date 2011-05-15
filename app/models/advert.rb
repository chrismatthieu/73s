class Advert < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :description, :url
  validates_format_of :content_type, :with => /^image/, 
  :message => "--- you can only upload images" 
  
  def advert=(advert_field) 
    self.name = base_part_of(advert_field.original_filename) 
    self.content_type = advert_field.content_type.chomp 
    self.data = advert_field.read 
  end 
  
  def base_part_of(file_name) 
    name = File.basename(file_name) 
    name.gsub(/[^\w._-]/, '') 
  end 
  
  
end
