class CreateCourseLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :course_lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
