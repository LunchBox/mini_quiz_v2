class AddRandomQuestionsToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :random_questions, :boolean, default: false
    add_column :quizzes, :random_questions_num, :integer, default: 10
  end
end
