class AddPermalinkToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :permalink, :string
  end
end
