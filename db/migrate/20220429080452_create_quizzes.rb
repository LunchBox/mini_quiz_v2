class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.string   "title"
      t.text     "desc"
      t.text     "pre_notice"
      t.boolean  "available",        default: false
      t.boolean  "random_questions", default: false
      t.boolean  "random_options",   default: false
      t.string   "calc_type"
      t.references  :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
