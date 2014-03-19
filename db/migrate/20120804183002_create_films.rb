class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.references :user
      t.string :title
      t.string :picture_url
      t.string :trailer_url
      t.text :summary
      t.string :path_movie
      t.timestamps
    end
  end
end
