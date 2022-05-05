class AddDurationToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :duration, :integer, default: 90 # minutes
    remove_column :quizzes, :end_at, :datetime
  end
end
