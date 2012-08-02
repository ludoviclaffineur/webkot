class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :author,  :null => false
      t.string :title,      :null => false
      t.text :content,      :null => false
      t.timestamps
    end
  end
end
