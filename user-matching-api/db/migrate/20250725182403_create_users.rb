class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.text :address
      t.text :bio
      t.string :employment_status
      t.text :about

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone
  end

  def down
    drop_table :users
  end
end
