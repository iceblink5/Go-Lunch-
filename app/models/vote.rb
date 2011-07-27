class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  def increment_and_update_attributes
    puts "PARAM:"
    param = Hash.new
    param["votes"] = self.votes + 1
    puts param.values_at("votes")
    self.update_attributes(param)
  end

  private

  def self.user_votes_today user_id
    Vote.where(:user_id  => user_id).where(
      'DATE(created_at) = DATE(?)', 
      #Time.now.utc.to_date
      Time.now.to_date
      ).size
  end

  def self.user_group_votes_today user_id, group_id
    Vote.where(:user_id  => user_id).where(
      'DATE(created_at) = DATE(?) AND group_id = ?', 
      #Time.now.utc.to_date,
      Time.now.to_date,
      group_id
      ).size
  end

  NUM_VOTES_ALLOWED = 3
end
