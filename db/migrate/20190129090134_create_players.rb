class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :phone2
      t.string :email

      t.boolean :receive_email
      t.boolean :receive_sms


      t.boolean :blacklist

      t.boolean :male
      t.string  :info_source

      t.string :city

      t.text :comment

      t.string :child_name
      t.date   :child_birth_date

      t.timestamps
    end

    add_index :players, :email,                unique: true
    add_index :players, :phone,                unique: true
  end
end
