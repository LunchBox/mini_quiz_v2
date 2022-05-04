class AddSyncToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :on_schedule, :boolean, default: false
    add_column :quizzes, :start_at, :datetime
    add_column :quizzes, :end_at, :datetime
  end
end
