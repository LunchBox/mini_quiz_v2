class AddSeqToAttemptAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :attempt_answers, :seq, :integer, defualt: 0
  end
end
