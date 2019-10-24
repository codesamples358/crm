class CreateCorpPackServices < ActiveRecord::Migration[5.2]
  def change
    create_table :corp_pack_services do |t|
      t.belongs_to :corp_pack, foreign_key: true
      t.belongs_to :service, foreign_key: true
      t.decimal :cost
      t.decimal :price
      t.boolean :ordered
      t.boolean :confirmed
      t.text :comment
      t.date :remind_at

      t.timestamps
    end
  end
end
