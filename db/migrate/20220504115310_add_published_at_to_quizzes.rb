class AddPublishedAtToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :published_at, :datetime
    remove_column :quizzes, :available, :boolean, default: false
  end
end
