class PlacesController < ApplicationController
  include MiscHelper

  def auth_user_signin
    puts "USER SIGNED IN STATUS"
    puts user_signed_in?
    unless user_signed_in?
      authenticate_user!
    end
  end

  # GET /places
  # GET /places.xml
  def index
    unless params[:group_id].nil? || params[:group_id] == ""
      @group = Group.find(params[:group_id])
      @invitations = @group.invitations
      @invitations = [@invitations] unless @invitations.is_a?(Array)
      @group_users = User.find(@invitations.map(&:user_id))
    end

    unless params[:called_from_index].nil?
      @called_from_index = true
    end

    unless current_user.nil?
      @my_groups = User.find(current_user.id).groups.group("group_id")
    end

    @vote = Vote.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @places }
    end
  end

  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id])
    @current_page_name = " | Place: #{@place.description}"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/new
  # GET /places/new.xml
  def new
    @current_page_name = " | New Place"
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.xml
  def create
    puts params
    @place = Place.new(:description => params[:place][:description],
                       :category_id => params[:category])

    respond_to do |format|
      if @place.save
        format.html { redirect_to(@place, :notice => 'Place was successfully created.') }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @selected_date = params[:selected_date]
    @group_id = params[:group_id]

    if @group_id.nil?
      redirect_to(places_path(
        :selected_date => @selected_date["selected_date"]))
    else
      redirect_to(places_path(
        :group_id => @group_id,
        :selected_date => @selected_date["selected_date"]))
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end
end
