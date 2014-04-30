module ApplicationHelper  
  def sortable(column, title = nil)  
    title ||= column.titleize  
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil  
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}  
  end  

  def title(page_title)
    content_for(:title) { page_title }  
  end  

  def search(search_title)
    content_for(:search) { search_title }  
  end  

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def nav_link(link_text, link_path)
    content_tag(:li, :class => nav_current(link_path)) do
      link_to link_text, link_path
    end
  end

  def nav_current(link_path)
    class_name = 'current' if params[:controller] == link_path.from(1)
    class_name = 'current' if 'bproceses' == link_path.from(1) && params[:controller] == 'bproces'
    return class_name
  end    

end  
