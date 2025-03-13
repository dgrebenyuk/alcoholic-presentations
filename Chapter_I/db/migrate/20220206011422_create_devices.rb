class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :ip
      t.string :netmask
      t.string :vendor
      t.integer :channels, default: 0
      t.text :description

      t.timestamps
    end
  end
end
