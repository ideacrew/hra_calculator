class AdminController < ApplicationController
  layout 'admin'
  
  def index
    # puts "in the controller"
    # binding.pry

    @admin = Admin.new
  end

  def premium_determination
  end
end