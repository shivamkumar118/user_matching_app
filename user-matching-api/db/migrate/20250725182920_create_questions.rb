class CreateQuestions < ActiveRecord::Migration[7.1]
  def up
    create_table :questions do |t|
      t.string :title, null: false
      t.string :category, null: false

      t.timestamps
    end
    
    add_index :questions, :title, unique: true
  end

  def down
    drop_table :questions
  end
end
