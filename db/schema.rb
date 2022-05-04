# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_04_021458) do

  create_table "attempt_answers", force: :cascade do |t|
    t.integer "attempt_id", null: false
    t.integer "question_id", null: false
    t.string "selected_options"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attempt_id"], name: "index_attempt_answers_on_attempt_id"
    t.index ["question_id"], name: "index_attempt_answers_on_question_id"
  end

  create_table "attempts", force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.string "name"
    t.datetime "start_at", precision: 6
    t.datetime "end_at", precision: 6
    t.float "score", default: 0.0
    t.string "auth_code"
    t.float "time_diff"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.index ["quiz_id"], name: "index_attempts_on_quiz_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "content"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "user_id", null: false
    t.string "subject"
    t.text "desc"
    t.string "correct_options"
    t.integer "score", default: 0
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: 6
    t.boolean "fixed_options", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.text "pre_notice"
    t.boolean "available", default: false
    t.boolean "random_questions", default: false
    t.boolean "random_options", default: false
    t.string "calc_type"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "anonymous", default: false
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attempt_answers", "attempts"
  add_foreign_key "attempt_answers", "questions"
  add_foreign_key "attempts", "quizzes"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "questions", "users"
  add_foreign_key "quizzes", "users"
end
