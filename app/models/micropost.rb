class Micropost < ActiveRecord::Base

  belongs_to :user

  attr_accessible :content


  default_scope :order => 'microposts.created_at DESC' 
    #pass a string that represents the order of the column

  validates :content, :length => { :maximum => 140 },
                        :presence => true
  validates :user_id, :presence => true

  scope :from_users_followed_by, lambda {|user| followed_by(user)}


  private
  
    def self.followed_by(user)
        followed_ids = %(SELECT followed_id FROM relationships 
                          WHERE follower_id = :user_id)
        self.where("user_id IN (#{followed_ids}) OR user_id = :user_id", 
                      :user_id => user)
    end
end
