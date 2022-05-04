class RenameRandomOptions < ActiveRecord::Migration[7.0]
  def change
    rename_column :quizzes, :random_questions, :shuffle_questions
    rename_column :quizzes, :random_options, :shuffle_options
  end
end
