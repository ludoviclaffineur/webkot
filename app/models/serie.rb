class Serie < ActiveRecord::Base
  has_many :episodes,  :foreign_key => "serie_id"
  attr_accessible  :title, :picture_url, :summary

  default_scope :order => "title ASC"
end
