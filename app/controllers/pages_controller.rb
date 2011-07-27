class PagesController < ApplicationController
  def home
    @my_votes = User.find(current_user.id).votes.find(:all, :group => 'DATE(created_at), place_id')
    @my_groups = User.find(current_user.id).groups.find(:all)
  end
end
