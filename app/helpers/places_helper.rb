module PlacesHelper

  def link_to_sorted name, group_id
    column_order = params[:sort_by]
    if column_order.nil? || !column_order.include?(name)
      up_down = "Up" 
    else
      if column_order.include?("Up")
        up_down = "Down"
      else
        up_down = "Up"
      end
    end
      link_to name,
        places_path(
        :group_id   =>   group_id,
        :selected_date  =>  params[:selected_date],
        :include   =>   params["include"],
        :called_from_index  =>  params[:called_from_index],
        :sort_by   =>  "#{name}#{up_down}")
  end

  def user_votes_left
    unless current_user.nil?
      votes = Vote.user_votes_today current_user.id
      Vote::NUM_VOTES_ALLOWED - votes
    else
      0
    end
  end

  def date_selected
    if params[:selected_date].nil?
      Time.now.to_date
      #Time.now.to_date
    else
      params[:selected_date]
    end
  end

  def places_filtered
    @places = Place.all_votes_per_place_per_group params[:group_id], params[:sort_by], params[:selected_date]

    unless params["include"].nil?
      @places = @places.select{|pl| params["include"].include?(pl.category_id.to_s)}
    end

    @places = Kaminari.paginate_array(@places).page(params[:page]).per(7)
  end

  def unvote_disable? place_id, group_id
    if current_user.nil?
      return true
    end
      Vote.where('DATE(created_at) = ? AND user_id = ? AND group_id = ? AND place_id = ?', Time.now.to_date, current_user.id, group_id, place_id).size == 0
  end

end
