class AddDefaultValueToUserMatchesScore < ActiveRecord::Migration[7.1]
  def change
    change_column :user_matches, :score, :integer, default: 0
  end
end
