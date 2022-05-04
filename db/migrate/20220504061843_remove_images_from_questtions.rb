class RemoveImagesFromQuesttions < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :image_file_name, :string
    remove_column :questions, :image_content_type, :string
    remove_column :questions, :image_file_size, :integer
    remove_column :questions, :image_updated_at, :datetime, precision: 6

    remove_column :question_options, :image_file_name, :string
    remove_column :question_options, :image_content_type, :string
    remove_column :question_options, :image_file_size, :integer
    remove_column :question_options, :image_updated_at, :datetime, precision: 6
  end
end
