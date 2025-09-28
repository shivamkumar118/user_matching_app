class CreateSkills < ActiveRecord::Migration[7.1]
  def up
    create_table :skills do |t|
      t.references :user, null: false, foreign_key: true
      t.string :value, null: false
      t.string :category, null: false
      t.integer :rating, null: false

      t.timestamps
    end
    
    add_check_constraint :skills, "rating >= 1 AND rating <= 5", name: "check_rating_range"
  end

  def down
    drop_table :skills
  end
end
