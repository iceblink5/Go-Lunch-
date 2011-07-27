class Group < ActiveRecord::Base
  has_many :invitations
  has_many :users, :through => :invitations 
  has_many :places, :through => :group_places 

  def update_invitations user_ids_to_include, group_id
    if user_ids_to_include
      user_ids_to_include.each do |userid|
        Invitation.delete_all(["user_id != ? and group_id = ?", userid, group_id])  
      end

      user_ids_to_include.each do |userid|
        logger.info userid
        logger.info group_id
        Invitation.create({:user_id  =>  userid, :group_id  =>  group_id})
      end
    else
      Invitation.delete_all(["group_id = ?", group_id])
    end
  end

  def self.by_user_and_date user_id, date
    if date.nil?
      date = Time.now.to_date
    end

    User.find(user_id).groups.where('DATE(groups.created_at) = DATE(?)', date).group("group_id")
  end
end
