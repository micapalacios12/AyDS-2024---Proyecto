# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_241_102_195_335) do
  create_table 'options', force: :cascade do |t|
    t.string 'text'
    t.boolean 'correct', default: false
    t.integer 'question_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['question_id'], name: 'index_options_on_question_id'
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'text'
    t.string 'system'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'level'
    t.integer 'correc_count', default: 0
    t.integer 'incorrect_count', default: 0
  end

  create_table 'users', force: :cascade do |t|
    t.string 'names'
    t.string 'username'
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', precision: nil, null: false
    t.datetime 'updated_at', precision: nil, null: false
    t.string 'avatar'
    t.string 'level_completed', default: '1,1,1,1'
    t.string 'role', default: 'user'
  end

  add_foreign_key 'options', 'questions'
end
