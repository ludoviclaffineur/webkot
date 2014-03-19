class SearchesController < ApplicationController
  def show
    if params[:title].blank?
      redirect_to films_path
    else
      @films = Film.find(:all, :conditions => ['lower(title) LIKE ?', "%#{params[:title].downcase}%" ])
    end
  end
end
