class GroupsController < ApplicationController

  def refresh_places_list
     @places = Place.all.select{|pl| params["selected_categories"].include?(pl.category_id.to_s)}
     @places = @places.select{|pl| !params["selected_list"].to_s.include?(pl.description)}
  end

  def index
    @current_page_name = " | Manage Groups"
    @group_id = params[:group_id]

    if @group_id.nil? || @group_id == ""
      @group_id = Group.find(User.find(current_user.id).invitations.map(&:group_id)).first.id
    end

    @place_ids = GroupPlace.where(:group_id => @group_id).map(&:place_id)
    @places = Place.all.select{|pl| !@place_ids.include?(pl.id)}
    @selected_places = Place.all.select{|pl| @place_ids.include?(pl.id)}

    unless params["include"].nil?
      @places = Place.all.select{|pl| params["include"].include?(pl.category_id.to_s)}
    end

    @my_groups = Group.find(User.find(current_user.id).invitations.map(&:group_id))
      
    @group = Group.find(@group_id)
    @invitations = @group.invitations
    @invitations = [@invitations] unless @invitations.is_a?(Array)
    @group_users = User.find(@invitations.map(&:user_id))
  end

  def new
    @current_page_name = " | New Group"
    logger.info params
    @categories = Category.all

    if params["include"].nil?
      @places = Place.all
    else
      @places = Place.all.select{|pl| params["include"].include?(pl.category_id.to_s)}
    end
  end

  def join
  end

  def update
    @group = Group.find(params[:group_id])
    @selected_places = params[:selected_places].split(',')
    @selected_places.each do |place|
      @place_id = Place.where(:description => place).first.id
      @group_place = GroupPlace.create(:group_id => @group.id,
                                    :place_id => @place_id) 
    end

    @group_places = GroupPlace.where(:group_id => @group.id)
    @group_places.each do |group_place|
      if !@selected_places.include?(Place.find(group_place.place_id).description)
        GroupPlace.delete(group_place.id)
      end
    end 

    @user_ids_to_include = params[:members]
    @group_id = params[:group_id]
    group = Group.find(@group_id)

    if @user_ids_to_include.nil?
      @user_ids_to_include = [current_user.id]
    else
      @user_ids_to_include = @user_ids_to_include + [current_user.id]
    end

    group.update_invitations @user_ids_to_include, @group_id

    puts "PARAMS"
    puts params
    @group.update_attribute(:name, params[:name])

    redirect_to(groups_path(:group_id  => @group_id));
  end

  def show
    @group = Group.find(params[:id])
    @invitations = @group.invitations
    @invitations = [@invitations] unless @invitations.is_a?(Array)
    @users = User.find(@invitations.map(&:user_id))

    # Create an invitation for the current user
    @group.invitations.create({
      :user_id  =>  current_user.id,
      :group_id =>  @group.id
    })
  end

  def create
    @group = Group.create(:name => params["name"])

    @selected_places = params[:selected_places].split(',')

    @selected_places.each do |place|
      @place_id = Place.where(:description => place).first.id
      @group_place = GroupPlace.create(:group_id => @group.id,
                                       :place_id => @place_id) 
    end

    unless params[:members].nil?
        params[:members].each do |user_id|
        Invitation.create(:user_id => user_id,
                      :group_id => @group.id)
      end
      @users =  User.find(params[:members])
    end

    Invitation.create(:user_id => current_user.id,
                      :group_id => @group.id)

    redirect_to(groups_path(:group_id  => @group.id));
  end
end
