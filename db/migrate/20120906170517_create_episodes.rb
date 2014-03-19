class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.integer :season_number
      t.integer :episode_number
      t.string :path_tvshow
      t.datetime :aired
      t.string :thumb_url 
      t.references :user
      t.references :serie

      t.timestamps
    end
  end
end
