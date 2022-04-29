class CreateAttemptAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :attempt_answers do |t|
      t.references  :attempt, null: false, foreign_key: true
      t.references  :question, null: false, foreign_key: true
      t.string   "selected_options"

      t.timestamps
    end
  end
end
