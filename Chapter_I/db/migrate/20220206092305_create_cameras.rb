class CreateCameras < ActiveRecord::Migration[7.0]
  def change
    create_table :cameras do |t|
      t.string :name
      t.string :username
      t.string :password
      t.integer :status, default: 0
      t.references :device

      t.timestamps
    end
  end
end
