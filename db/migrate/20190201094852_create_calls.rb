class CreateCalls < ActiveRecord::Migration[5.2]
  def up
    create_table :calls do |t|

      t.string :uuid          # =>"d4999b0a-bfac-4652-bec4-3f355b0f1820",
      t.string :caller        # =>"100",
      t.string :caller_name   # =>"EXPERIMENTIKUM",
      t.string :from_domain   # =>"experimentikum.onpbx.ru",
      t.string :to            # =>"89044722507",
      t.string :to_domain     # =>"experimentikum.onpbx.ru",
      t.string :gateway       # =>"83462550599",

      t.datetime :time        # =>"1549009348",
      t.integer  :duration    # =>"34",
      t.integer  :billsec     # =>"19",

      t.string :hangup_cause  # =>"NORMAL_CLEARING",
      t.string :call_type     # =>"outbound"


      t.string :status
      t.belongs_to :player, index: true

      t.timestamps
    end

    add_index :calls, :uuid, unique: true
    add_index :calls, :caller
    add_index :calls, :to
  end

  def down
    drop_table :calls
  end
end
