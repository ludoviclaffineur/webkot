class Episode < ActiveRecord::Base
  belongs_to :user, :class_name => "User"
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :serie, :class_name => "Serie"
  attr_accessible :season_number, :user, :path_tvshow, :title, :episode_number, :serie, :thumb_url, :aired, :serie_id

  #default_scope :order =>  "season_number DESC, episode_number DESC"
  scope :order_by, lambda { |o| {:order => o} }
  
  def has_subtitle?
    has_subtitle_srt? || has_subtitle_fr_srt?
  end
  
  def has_subtitle_fr_srt?
    File.file?('/data/series/' + File.split(path_tvshow)[0][7..-1]  + "/" +  File.basename('/data/' + path_tvshow, File.extname('/data/' + path_tvshow)) + '.fr.srt')
  end
  
  def has_subtitle_srt?
    File.file?('/data/series/' + File.split(path_tvshow)[0][7..-1]  + "/" +  File.basename('/data/' + path_tvshow, File.extname('/data/' + path_tvshow)) + '.srt')
  end
  
  def subtitle
    if has_subtitle_srt?
      File.split(path_tvshow)[0] + "/" +  File.basename('/data/' + path_tvshow, File.extname('/data/' + path_tvshow)) + '.srt'
    elsif has_subtitle_fr_srt?
      File.split(path_tvshow)[0] + "/" +  File.basename('/data/' + path_tvshow, File.extname('/data/' + path_tvshow)) + '.fr.srt'
    end
  end
end
