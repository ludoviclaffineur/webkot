class FilmsController < ApplicationController
  require 'rexml/document'
  require 'fileutils'
  before_filter :load_commentable, :only => [:show]
  before_filter :authenticate_user!
  before_filter :update_action
  def destroy
    @film = Film.find(params[:id])
    if File.file?("/data/" + @film.path_movie)
      FileUtils.mv("/data/" + @film.path_movie, '/data/deleted_stuffs/')
    end
    @film.destroy
    flash[:notice] = "Movie successfuly erased"
    redirect_to films_path
  end

  def new
    @film = Film.new
    @path = params[:path]
    if @path.nil?
      @path=''
    end
    @filename = params[:filename]
  end

  def create
    if @path.nil?
      @path=''
    end
    @film_title = Film.new(params[:film])
    @film_info = InfoFromWeb.new
    unless @film_title.nil?
      @film = @film_info.film_informations_from_title(@film_title.title)
      unless @film.nil?
        @film.user = current_user
        salt = ''
        
        if File.file?('/data/films/' + @film.title.gsub('/', ' ') + File.extname('/data/download/' + @film_title.path_movie))
          salt = (Time.now)
        end
        FileUtils.mv('/data/download/' + @film_title.path_movie, '/data/films/' +  @film.title.gsub('/', ' ') + salt.to_s + File.extname('/data/download/' + @film_title.path_movie))
        @film.path_movie = 'films/' + @film.title.gsub('/', ' ') + salt.to_s + File.extname('/data/download/' + @film_title.path_movie)
        respond_to do |format|
          if @film.save
            format.html { redirect_to @film, notice: 'Film was successfully created.' }
            format.json { render json: @film, status: :created, location: @film }
          else
            format.html { render action: "new" }
            format.json { render json: @film.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:alert] =  "No match for the movie please check the informations"
        redirect_to new_film_path
      end
    else
      redirect_to new_film_path 
    end

  end

  def edit
    @film = Film.find(params[:id])
  end

  def update
    @film = Film.find(params[:id])

    if @film.update_attributes(params[:film])
      redirect_to @film, notice: 'Film was successfully updated.'
    else
      flash[:alert] = 'Oups there are some problems'
      render edit
    end
  end

  def show
    @film = Film.find(params[:id])
    @user = @film.user
    @comments = @film.comments
    @comment =  @commentable.comments.new
    @src = "http://www.youtube.com/embed/#{@film.trailer_url}"
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @film }
    end
  end

  def index
    @page = params[:page].to_i
    @order = params[:order]
    if (@order == 'recent')
      if !@page.nil? && @page>0
        @films_recent = Film.order_by('created_at DESC')[25*(@page-1)..25*(@page)-1]
      else
        @page = 1
        @films_recent = Film.order_by('created_at DESC')[25*(@page-1)..25*(@page)-1]
      end
    elsif (@order == 'alpha')
      if !@page.nil? && @page>0
        @films = Film.order_by('title ASC')[25*(@page-1)..25*(@page)-1]
      else
        @page = 1
        @films = Film.order_by('title ASC')[25*(@page-1)..25*(@page)-1]
      end
    else
      @films_recent = Film.order_by('created_at DESC')[0..9]
      @films = Film.order_by('title ASC')[0..9]
    end
  end

  private

  def import_xml
    file = File.open("/Users/ludoviclaffineur/webkot/videodb.xml")
    xml_data = REXML::Document.new(file)
    titles = []
    picture_urls = []
    summaries = []
    paths = []
    xml_data.elements.each('videodb/movie') do |ele|
      film= Film.new
      film.title = ele.elements["title"].text
      film.user = current_user
      puts(film.title)
      unless ele.elements["plot"].nil? && ele.elements["plot"].text.nil?
        film.summary = ele.elements["plot"].text
      end
      unless ele.elements["thumb"].nil?
        film.picture_url = ele.elements["thumb"].text
      end
      film.path_movie = (ele.elements["filenameandpath"].text).gsub("smb://172.16.1.100/", "")
      unless ele.elements["trailer"].nil?
        unless ele.elements["trailer"].text.nil?
          film.trailer_url = (ele.elements["trailer"].text).gsub("plugin://plugin.video.youtube/?action=play_video&amp;videoid=","")
        end
      end
      film.save
    end
  end

  def load_commentable
    @commentable = CommentableHandler.load_commentable(request)
  end
  
  def update_action
    unless current_user.nil?
      current_user.update_action
    end
  end
end
