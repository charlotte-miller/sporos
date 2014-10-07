module ApplicationHelper
  
  def is_homepage?
    current_page?(controller:'special_pages', action:'homepage')
  end
  
  def homepage_toggle
    capture_haml do
      haml_tag :div, id:'main-page', class:"#{'current' if is_homepage?}" do
        yield if is_homepage?
      end
    
      haml_tag :div, id:'page', class:"#{'current' unless is_homepage?}" do
        yield unless is_homepage?
      end
    end
  end
  
end
