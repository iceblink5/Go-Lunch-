module GroupsHelper

  def places_based_on_category
    if params["include"].nil?
      @places = Place.all
    else
      @places = Place.all.select{|pl| params["include"].include?(pl.category_id.to_s)}
    end
  end

  def update_group_places
  end
end
