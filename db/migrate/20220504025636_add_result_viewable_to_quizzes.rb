class AddResultViewableToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :result_viewable, :boolean, default: false
  end
end
