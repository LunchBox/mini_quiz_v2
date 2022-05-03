class RemoveInfoFromAtempts < ActiveRecord::Migration[7.0]
  def change
    remove_column :attempts, :school, :string
    remove_column :attempts, :email, :string
    remove_column :attempts, :mobile, :string
  end
end
