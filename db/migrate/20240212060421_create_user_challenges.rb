class CreateUserChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :user_challenges do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :challenge, null: false, foreign_key: true
      t.text :code
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
