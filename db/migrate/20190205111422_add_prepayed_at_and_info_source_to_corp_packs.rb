class AddPrepayedAtAndInfoSourceToCorpPacks < ActiveRecord::Migration[5.2]
  def change
    add_column :corp_packs, :prepayed_at, :datetime
    add_column :corp_packs, :info_source, :string
  end
end
