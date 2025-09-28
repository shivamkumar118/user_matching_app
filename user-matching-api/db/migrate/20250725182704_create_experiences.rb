class CreateExperiences < ActiveRecord::Migration[7.1]
  def up
    create_table :experiences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :job_title, null: false
      t.string :company_name, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :experiences
  end
end
