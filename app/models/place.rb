class Place < ActiveRecord::Base

  has_many :votes
  belongs_to :category
  has_many :groups, :through => :group_places 

#  has_attached_file :avatar, :styles  =>  { :medium  =>  "300x300>", :thumb  =>  "100x100>", :default_url  =>  "/images/normal/missing.png"}

  def votes_at_date date, group_id
    if group_id.nil?
      self.votes.where('DATE(created_at) = DATE(?)', date)
    else
      self.votes.where('DATE(created_at) = DATE(?) AND group_id = ?', date)
    end
  end

  def self.all_votes_per_place_per_group group_id, sort_by, date_selected

    if date_selected.nil?
      date_selected = Time.now.to_date
    else
      date_selected = date_selected
    end

    if sort_by.nil?
      sort_val = "number_of_votes"
      sort_dir = "DESC"
    else
      case 
        when sort_by.include?("Genre")
          sort_val = "category"
        when sort_by.include?("Place")
          sort_val = "description"
        when sort_by.include?("Votes")
          sort_val = "number_of_votes"
        end
      if sort_by.include?("Up")
        sort_dir = "ASC"
      else
        sort_dir = "DESC"
      end
    end

    joins = "join categories on categories.id = places.category_id"

    unless group_id.nil? || group_id == ""
      joins = "join group_places on places.id = group_places.place_id
               join categories on categories.id = places.category_id"
      select_conditions = ["group_places.group_id = ?", group_id]
    end

    @all_places = all(
       :select => "places.*,
                    0 number_of_votes,
                    categories.name category",
       :from   => "places",
       :joins  => joins,
       :conditions => select_conditions,
       :group  => "places.id",
       :order  => "#{sort_val} #{sort_dir}")

    if group_id.nil? || group_id == ""
      select_condition = ["DATE(votes.created_at) = DATE(?)", date_selected]
    else
      select_condition = ["DATE(votes.created_at) = DATE(?) and votes.group_id = ?", date_selected, group_id]
    end

    @places = all(
       :select => "places.*,
                    COUNT(votes.id) number_of_votes,
                    categories.name category",
       :from   => "places",
       :joins  => "join votes on places.id = votes.place_id 
                   join categories on categories.id = places.category_id",
       :conditions => select_condition,
       :group  => "places.id",
       :order  => "#{sort_val} #{sort_dir}")

    @places_descriptions = @places.map(&:description)
    @all_places.delete_if{|place| @places_descriptions.include?(place.description) } 

    @places = @places +  @all_places
    return @places
  end
end
