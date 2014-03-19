class FilmsController < ApplicationController
  require 'rexml/document'
  def new
    @film = Film.new
  end

  def create
      @film = Film.new(params[:film])
      @film.user = current_user
      respond_to do |format|
        if @film.save
          format.html { redirect_to @film, notice: 'Film was successfully created.' }
          format.json { render json: @film, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @film.errors, status: :unprocessable_entity }
        end
      end
  end

  def edit
  end

  def show
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

  def index
    @films = Film.all[0, 50]
  end
end
