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

  def markdown(text)
    simple_format(text, {}, {})
  end

  def markdown_and_link(text, business_roles)
    if business_roles
      business_roles.each do |business_role|  # заменим названия роли на ссылку
        text.gsub!(/(^|\s|^\s)#{business_role.name}($|\s)/, ' <a href="/business_roles/' + business_role.id.to_s + '">' + business_role.name + '</a> ')
      end
    end
    text.gsub!(/\r\n?/, "\n")                       # \r\n and \r => \n
    text = "<p>#{text.gsub(/\n\n\s*/, '</p><p>')}"  # 2 newline   => p
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')    # 1 newline   => br
    return text
  end

  def add_link_from_id(text, route)
    aid = text.match('(^|\s|^\s)#([1-9]\d+)($|\s)') # ищем ID в тексте
    if aid
      text.gsub!(/#{aid[0]}/, ' <a href="/' + route + '/' + aid[2] + '">' + aid[0].strip + '</a> ')
    end
    text.gsub!(/\r\n?/, "\n")                       # \r\n and \r => \n
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')    # 1 newline   => br
    return text
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
