class Post < ActiveRecord::Base
   belongs_to :author, :class_name => "User"
   has_many :comments, :as => :commentable, :dependent => :destroy

  attr_accessible :content, :title
  default_scope :order => "created_at DESC"
end
