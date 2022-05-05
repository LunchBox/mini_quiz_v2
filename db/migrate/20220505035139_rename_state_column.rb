class RenameStateColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :attempts, :state, :aasm_state
  end
end
