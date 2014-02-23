class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :position_x
      t.integer :position_y

      t.timestamps
    end
  end
end
