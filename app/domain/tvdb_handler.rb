

class TvdbHandler
  require 'tvdb_party'
  require 'rubygems'
  def initialize
    @tvdb = TvdbParty::Search.new("F504C5E62725F2FA")
    @serie
  end

  def search_with_name name
    results = @tvdb.search(name)
    @serie = @tvdb.get_series_by_id(results.first["seriesid"])
  end

  def episode_from_season(season_number, episode_number)
    episode_tvdb = @serie.get_episode(season_number, episode_number)
    @episode = Episode.new
    @episode.season_number = season_number
    @episode.episode_number = episode_number
    @episode.title = episode_tvdb.name
    @episode.thumb_url = episode_tvdb.thumb
    @episode.aired = episode_tvdb.air_date
    @episode
  end
  
  def search_serie_info_with_name name
    results = @tvdb.search(name)
    @serie_web = @tvdb.get_series_by_id(results.first["seriesid"])
    serie_new= Serie.new
    serie_new.picture_url ="http://thetvdb.com/banners/" + @serie_web.series_banners('en').first.path
    serie_new.title =  @serie_web.name
    serie_new.summary = @serie_web.overview
    serie_new
  end


end