class FeedsController < ApplicationController

  before_filter   :secure_controller
  
  def history
    @histories  = History.for_user @user
    render :template => 'feeds/history.xml.builder', :layout => false
  end

end
