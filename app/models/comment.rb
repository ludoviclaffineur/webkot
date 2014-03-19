class Comment < ActiveRecord::Base
  attr_accessible :content
  belongs_to :commentable, :polymorphic => true
  belongs_to :commenter, :class_name => "User"
  validates :content, :presence => true
  default_scope :order => "created_at DESC"
end
