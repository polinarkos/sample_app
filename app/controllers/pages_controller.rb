class PagesController < ApplicationController
  def home
    @title = "Home"
    @tagline = ""
  end

  def contact
    @title = "Contact"
    @tagline = "Where to find us" 
  end

  def about
    @title = "About"
    @tagline = "Get to know us"
  end
  
  def help
    @title = "Help"
    @tagline = "Let us help you"
  end
end
