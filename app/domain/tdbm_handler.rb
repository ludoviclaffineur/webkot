class TdbmHandler
  require 'rubygems'
  require 'ruby-tmdb'

  def initialize
    # setup your API key
    Tmdb.api_key = "ea1bf296dc469c1f9ce6c4a9f579e19f"

    # setup your default language
    Tmdb.default_language = "en"
  end

  def info_from_title (title)
    @thefilm = Film.new
    movie = TmdbMovie.find(:title => title, :limit => 1 )
    unless movie.empty?
      @thefilm.title = movie.original_name
      @thefilm.picture_url = movie.image
      @thefilm.summary = movie.overview
      @thefilm.picture_url = movie.posters.collect(&:url)[4]
      @thefilm
    end
  end
end