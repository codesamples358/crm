class CreateCorpPacks < ActiveRecord::Migration[5.2]
  def change
    create_table :corp_packs do |t|
      t.integer :manager_id

      t.string :mode
      t.string :status

      t.string :prepayment_type

      t.decimal :prepayment_sum
      t.date    :prepayment_deadline


      t.string :payment_type

      t.date :date
      t.time :time

      t.datetime :datetime

      t.belongs_to :player

      t.text :comment

      t.string :game_center

      t.timestamps
    end
  end
end
