class CreateServices < ActiveRecord::Migration[5.2]
  def up
    create_table :services do |t|
      t.string :name
    end

    Service::LIST.each do |name|
      Service.create!(name: name)
    end
  end

  def down
    drop_table :services
  end
end
