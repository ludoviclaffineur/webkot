class SeriesController < ApplicationController
  before_filter :update_action
  
  def new
    @serie = Serie.new
  end

  def show
    @serie = Serie.find(params[:id])
    @episodes = @serie.episodes.order_by('season_number DESC, episode_number DESC')
  end

  def create
    @serie = Serie.new(params[:serie])
    tvdb = TvdbHandler.new
    @serie = tvdb.search_serie_info_with_name(@serie.title)
    if @serie.save
      redirect_to @serie, notice: 'TV Show was successfully created.'
    end
  end

  def edit
    @serie = Serie.find(params[:id])
  end

  def update
    @serie = Serie.find(params[:id])

    if @serie.update_attributes(params[:serie])
      redirect_to @serie, notice: 'Film was successfully updated.'
    else
      flash[:alert] = 'Oups there are some problems'
      render edit
    end
  end

  def index
    #import_xml
    @series = Serie.all
    @page = params[:page].to_i
    @order = params[:order]
  end

  private

  def import_xml
    file = File.open("/home/luds/webkot/videodb.xml")
    xml_data = REXML::Document.new(file)
    xml_data.elements.each('videodb/tvshow') do |ele|
      serie= Serie.new
      serie.title = ele.elements["title"].text
      puts(serie.title)
      unless ele.elements["plot"].nil? && ele.elements["plot"].text.nil?
        serie.summary = ele.elements["plot"].text
      end
      unless ele.elements["thumb"].nil?
        serie.picture_url = ele.elements["thumb"].text
      end
      serie.save
    end
  end
  def update_action
    unless current_user.nil?
      current_user.update_action
    end
  end
end
