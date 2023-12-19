ActiveRecord::Schema[7.1].define(version: 2023_12_19_155801) do
  create_table "matches", force: :cascade do |t|
    t.integer "number_of_rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_matches", force: :cascade do |t|
    t.integer "score", default: 0
    t.integer "user_id", null: false
    t.integer "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_user_matches_on_match_id"
    t.index ["user_id"], name: "index_user_matches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "user_matches", "matches"
  add_foreign_key "user_matches", "users"
end
