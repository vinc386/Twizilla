class PagesController < ApplicationController
  
  # def initialize
  #   @title = ""
  #   
  #   def pg_title
  #     @title.capitalize
  #   end
  # end
  
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
end
