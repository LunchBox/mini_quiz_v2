class ChangeQuizzedPublishedAtToBoolean < ActiveRecord::Migration[7.0]
  def change
    remove_column :quizzes, :publiched_at, :datetime
    add_column :quizzes, :published, :boolean, default: false
  end
end
