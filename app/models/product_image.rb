class ProductImage
  include Mongoid::Document

  mount_uploader :image, ProductImageUploader
  belongs_to :product
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_image
  
  def crop_image
  	image.recreate_versions! if crop_x.present?
  end
  
end
