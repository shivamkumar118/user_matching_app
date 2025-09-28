class CreateAnswers < ActiveRecord::Migration[7.1]
  def up
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :answer_text, null: false

      t.timestamps
    end
    
    add_index :answers, [:user_id, :question_id], unique: true
  end

  def down
    drop_table :answers
  end
end
