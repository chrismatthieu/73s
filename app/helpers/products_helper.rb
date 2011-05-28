module ProductsHelper

  include ActionView::Helpers::AssetTagHelper
 
  def prodimage product, size = :square, img_opts = {}
    return image_tag(image_path( product, size), :class => size) if product.image.blank?
    img_tag = image_tag(product_path( product, size), {:title=>product.name, :alt=>product.name, :class=>size}.merge(img_opts))
    img_tag
  end
  
  def product_path product = nil, size = :square
    path = nil
    unless product.nil? || product.image.blank?
      # path = url_for_file_column(product, :image, size.to_s) rescue nil
    end
    path = missing_product_path(size) if path.nil?
    return path
  end
 
  def allowed_product_sizes
    [:square, :small]
  end
 
  def missing_product_path(size)
    if allowed_product_sizes.include?(size)
      "/images/missing_#{size}.png"
    else
      '/images/missing.png'
    end
  end
 
  def image_path_with_product(source_or_product, size = :square)
    source_or_product.respond_to?(:image) ? product_path(source_or_product, size) : image_path_without_product(source_or_product)
  end
  alias_method_chain :image_path, :product

end
