module CompaniesHelper
  include ActionView::Helpers::AssetTagHelper
 
  def compimage company, size = :square, img_opts = {}
    return image_tag(image_path( company, size), :class => size) if company.image.blank?
    img_tag = image_tag(company_path( company, size), {:title=>company.name, :alt=>company.name, :class=>size}.merge(img_opts))
    img_tag
  end
  
  def company_path company = nil, size = :square
    path = nil
    unless company.nil? || company.image.blank?
      # path = url_for_file_column(company, :image, size.to_s) rescue nil
    end
    path = missing_company_path(size) if path.nil?
    return path
  end
 
  def allowed_company_sizes
    [:square, :small]
  end
 
  def missing_company_path(size)
    if allowed_company_sizes.include?(size)
      "/images/missing_#{size}.png"
    else
      '/images/missing.png'
    end
  end
 
  def image_path_with_company(source_or_company, size = :square)
    source_or_company.respond_to?(:image) ? company_path(source_or_company, size) : image_path_without_company(source_or_company)
  end
  alias_method_chain :image_path, :company

end
