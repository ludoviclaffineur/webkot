class AddLastActionToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_action, :datetime
  end
end
