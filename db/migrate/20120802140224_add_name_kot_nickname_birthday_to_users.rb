class AddNameKotNicknameBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :kot, :string
    add_column :users, :nickname, :string
    add_column :users, :birthday, :datetime
    add_column :users, :studies, :string
  end
end
