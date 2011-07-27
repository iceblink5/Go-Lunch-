class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
