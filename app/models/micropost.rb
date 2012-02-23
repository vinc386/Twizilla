class Micropost < ActiveRecord::Base

  belongs_to :user

  attr_accessible :content


  default_scope :order => 'microposts.created_at DESC' 
    #pass a string that represents the order of the column

  validates :content, :length => { :maximum => 140 },
                        :presence => true
  validates :user_id, :presence => true


end
