class VotesController < ApplicationController
  def create
    if params[:commit] == "UnVote"
      puts "unvote == true"
      votes = Vote.where(:user_id  => params[:vote][:user_id],
                 :place_id => params[:vote][:place_id],
                 :group_id => params[:vote][:group_id]
                ).order('created_at DESC')
      votes.first.destroy
      redirect_to(:back)
    else
      puts "unvote == false"
      @vote = Vote.new(params[:vote])

      respond_to do |format|
        if @vote.save
          format.html { redirect_to(@vote, :notice => 'Vote was successfully created.') }
          format.xml  { render :xml => @vote, :status => :created, :location => @vote }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def show
    @vote = Vote.find(params[:id])
    redirect_to(places_path(:group_id  => @vote.group_id));
  end

end
