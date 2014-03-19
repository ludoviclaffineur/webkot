class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :title
      t.text :summary
      t.string :picture_url
      t.timestamps
    end
  end
end
