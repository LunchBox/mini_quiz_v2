class CreateAttempts < ActiveRecord::Migration[7.0]
	def change
		create_table :attempts do |t|
      t.references  :quiz, null: false, foreign_key: true
			t.string   "name"
			t.datetime "start_at"
			t.datetime "end_at"
			t.float    "score",      default: 0.0
			t.string   "auth_code"
			t.string   "school"
			t.string   "email"
			t.string   "mobile"
			t.float    "time_diff"

			t.timestamps
		end
	end
end
