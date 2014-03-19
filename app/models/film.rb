class Film < ActiveRecord::Base

  scope :order_by, lambda { |o| {:order => o} }

  attr_accessible :picture_url, :user, :title, :trailer_url, :summary, :path_movie, :filename
  belongs_to :user, :class_name => "User"
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessor :filename
  #default_scope :order => "created_at DESC"

end
