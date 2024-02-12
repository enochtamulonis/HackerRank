class AddTestsToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :tests, :text
  end
end
