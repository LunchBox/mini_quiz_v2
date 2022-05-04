class AddAnonymousToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :anonymous, :boolean, default: false
  end
end
