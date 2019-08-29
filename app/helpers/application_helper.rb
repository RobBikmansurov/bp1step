# frozen_string_literal: false

module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.permit.merge(sort: column, direction: direction, page: nil), class: css_class
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
    business_roles&.each do |business_role| # заменим названия роли на ссылку
      role_link = "<a href=\"/business_roles/#{business_role.id}\"> #{business_role.name} </a>"
      text.gsub!(/(^|\s|^\s)#{business_role.name}($|\s|\.|,)/, role_link)
    end
    text.gsub!(/\r\n?/, "\n")                       # \r\n and \r => \n
    text = "<p>#{text.gsub(/\n\n\s*/, '</p><p>')}"  # 2 newline   => p
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')    # 1 newline   => br
    text
  end

  def add_link_from_id(text, route)
    return '' unless text

    aid = text.match('(^|\s|^\s)#([1-9]\d+)($|\s|\.|,)') # ищем ID в тексте
    text.gsub!(/#{aid[0]}/, ' <a href="/' + route + '/' + aid[2] + '">' + aid[0].strip + '</a> ') if aid
    text.gsub!(/\r\n?/, "\n")                       # \r\n and \r => \n
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')    # 1 newline   => br
    text
  end

  def nav_link(link_text, link_path)
    content_tag(:li, class: nav_current(link_path)) do
      link_to link_text, link_path
    end
  end

  def nav_current(link_path)
    class_name = 'current' if params[:controller] == link_path.from(1)
    class_name = 'current' if link_path.from(1) == 'bproceses' && params[:controller] == 'bproces'
    class_name
  end

  def status(status)
    status&.positive? ? 'отв.' : ''
  end

  def format_content(name)
    truncate(name, length: 150, omission: ' ...')
  end

  def red_text(text, condition)
    return text unless condition

    raw("<span style='color: red;'>#{text}</span>")
  end

  def days_left_as_text(duedate, alarm)
    days = (Date.current - duedate).to_i
    return duedate.strftime('%d.%m.%y') if days < -2
    return red_text(duedate.strftime('%d.%m.%y'), alarm) if days > 1

    if days.zero?
      red_text 'сегодня', true
    elsif days == -1
      red_text 'завтра', true
    elsif days == 1
      red_text 'вчера', true
    elsif days.negative?
      red_text 'скоро', true
    else
      '?? ?? ??'
    end
  end

  def date_as_text(date, alarm)
    red_text date.strftime('%d.%m.%y'), alarm
  end
end
