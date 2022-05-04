class AddSeqToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :seq, :integer, default: 0
  end
end
