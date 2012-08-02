class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :nickname, :birthday, :kot,:studies, :avatar
  # attr_accessible :title, :body


  has_attached_file :avatar, {:styles => { :medium => "200x200#", :thumb => "50x50#" }, :default_url => "/assets/default_avatar_:style.png"}

  validates_attachment :avatar, :content_type => { :content_type => /image/ }
  has_many :posts, :foreign_key => "author_id"
end
