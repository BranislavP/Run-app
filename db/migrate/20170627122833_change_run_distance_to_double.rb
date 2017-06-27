class ChangeRunDistanceToDouble < ActiveRecord::Migration[5.0]
  def change
    change_column :runs, :distance, :float
  end
end
