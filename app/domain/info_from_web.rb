class InfoFromWeb
  def initialize

  end

  def serie_informations_from_title_season_episode(title, season, episode)
    tvdb = TvdbHandler.new
    tvdb.search_with_name(title)
    tvdb.episode_from_season(season, episode)
  end

  def film_informations_from_title(title)
    tdbm  = TdbmHandler.new
    film = tdbm.info_from_title(title)
    youtube_info = YoutubeSearch.search(film.title + ' trailer').first
    film.trailer_url = youtube_info['video_id']
    film
  end
end