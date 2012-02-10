module ApplicationHelper

  # make sure the title is right for pages other than the home page
  def title
    base_title = "Twizilla"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "twizilla", :class => 'round')
  end
end
