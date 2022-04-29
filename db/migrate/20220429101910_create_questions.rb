class CreateQuestions < ActiveRecord::Migration[7.0]
	def change
		create_table :questions do |t|
      t.references  :quiz, null: false, foreign_key: true
      t.references  :user, null: false, foreign_key: true
			t.string   "subject"
			t.text     "desc"
			t.string   "correct_options"
			t.integer  "score",              default: 0
			t.string   "image_file_name"
			t.string   "image_content_type"
			t.integer  "image_file_size"
			t.datetime "image_updated_at"
			t.boolean  "fixed_options",      default: false

			t.timestamps
		end
	end
end
