class CreateTimelines < ActiveRecord::Migration[7.0]
  def change
    create_table :timelines do |t|
      t.string :name

      t.timestamps
    end
  end
end
