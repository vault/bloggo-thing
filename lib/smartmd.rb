module Haml::Filters::SmartMD
  include Haml::Filters::Base
  def render(text)
    RDiscount.new(text, :smart, :autolink).to_html  
  end
end
