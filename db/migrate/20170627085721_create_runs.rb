class CreateRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :runs do |t|
      t.integer :distance
      t.time :duration
      t.datetime :date

      t.timestamps
    end
    add_reference :runs, :user, index: true
  end
end
