module ApplicationHelper
  def full_title(page_title = '', base_title = 'SGTCC')
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end

def namespace
  controller.class.parent.to_s.downcase
end