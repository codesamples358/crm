class AddCallIdToCorpPacks < ActiveRecord::Migration[5.2]
  def change
    add_column :corp_packs, :call_id, :integer
    add_index :corp_packs, :call_id
  end
end
