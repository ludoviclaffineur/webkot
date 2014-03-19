class EpisodesController < ApplicationController

  before_filter :load_commentable, :only => [:show]
  before_filter :authenticate_user!
  before_filter :update_action
  def new
    @episode = Episode.new
    @episode.serie = Serie.find_by_id(params[:serieid])
    @path = params[:path]
    if @path.nil?
      @path=''
    end
    @filename = params[:filename]
  end
  
  def create
    episode_old = Episode.new(params[:episode])
    info_film = InfoFromWeb.new
    @episode = info_film.serie_informations_from_title_season_episode(episode_old.serie.title, episode_old.season_number,episode_old.episode_number)
    @episode.serie_id = episode_old.serie_id
    @episode.path_tvshow = episode_old.path_tvshow
   # @episode = Episode.new(params[:episode])
    
    puts @episode.season_number
    puts @episode.episode_number
    puts @episode.serie.title
    puts @episode.title
    puts @episode.thumb_url
    puts @episode.aired
    unless File.directory?('/data/series/' + @episode.serie.title + '/season '+ @episode.season_number.to_s)
      FileUtils.mkdir_p ('/data/series/' + @episode.serie.title + '/season ' + @episode.season_number.to_s)
    end
    FileUtils.mv('/data/download/' + @episode.path_tvshow, '/data/series/' + @episode.serie.title + '/season ' +  @episode.season_number.to_s + '/' +   @episode.serie.title + " " + @episode.season_number.to_s + "x" + @episode.episode_number.to_s + " " + @episode.title.gsub('/', ' ').gsub("'"," ").gsub("!","").gsub("?","") + File.extname('/data/download/' + @episode.path_tvshow))
    @episode.path_tvshow = 'Series/' + @episode.serie.title + '/season ' +  @episode.season_number.to_s + '/' +   @episode.serie.title + " " + @episode.season_number.to_s + "x" + @episode.episode_number.to_s + " " + @episode.title.gsub('/', ' ').gsub("'"," ").gsub("!","").gsub("?","")  + File.extname('/data/download/' + @episode.path_tvshow)
    if @episode.save
      redirect_to @episode, notice: 'Episode was successfully created.'
    else
      render action: "new" 
    end
  end
  
  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy
    redirect_to series_index_path, notice: 'Episode was successfully deleted.'
  end
  
  def edit
    @episode = Episode.find(params[:id])
  end

  def update
     @episode = Episode.find(params[:id])

    if @episode.update_attributes(params[:episode])
      redirect_to @episode, notice: 'Episode was successfully updated.'
    else
      flash[:alert] = 'Oups there are some problems'
      render edit
    end
  end
  
  def show
    @episode = Episode.find(params[:id])
    @comments = @episode.comments
    @comment =  @commentable.comments.new
  end

  private

  def import_xml
    file = File.open("/Users/ludoviclaffineur/webkot/videodb.xml")
    xml_data = REXML::Document.new(file)
    xml_data.elements.each('videodb/tvshow/episodedetails') do |e|
      title = e.elements["showtitle"].text
      serie = Serie.find_by_title(title)
      episode = Episode.new

      episode.path_tvshow = (e.elements["filenameandpath"].text).gsub("smb://172.16.1.100/", "")
      episode.user = current_user
      episode.season_number = e.elements["season"].text
      episode.episode_number = e.elements["episode"].text
      unless e.elements["aired"].nil?
        episode.aired = e.elements["aired"].text
      end
      unless e.elements["thumb"].nil?
        episode.thumb_url = e.elements["thumb"].text
      end
      if e.elements["title"].nil?
        episode.title = title + episode.season_number + "x" + episode.episode_number
      else
        episode.title = e.elements["title"].text
      end
      episode.serie = serie
      puts(episode.title)

      episode.save

    end
  end

  def update_action
    unless current_user.nil?
      current_user.update_action
    end
  end
  def load_commentable
    @commentable = CommentableHandler.load_commentable(request)
  end
end
