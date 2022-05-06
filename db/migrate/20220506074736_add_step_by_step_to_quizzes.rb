class AddStepByStepToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :step_by_step, :boolean, default: false
  end
end
