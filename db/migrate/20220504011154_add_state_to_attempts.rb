class AddStateToAttempts < ActiveRecord::Migration[7.0]
  def change
    add_column :attempts, :state, :string
  end
end
