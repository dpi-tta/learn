class AddPositionToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :position, :integer
  end
end
