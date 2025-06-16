class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :description
      t.text :content
      t.string :github_repository_url
      t.string :github_repository_branch, default: "main"
      t.string :slug

      t.timestamps
    end
  end
end
