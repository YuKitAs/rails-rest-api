ActiveRecord::Schema.define(version: 20180323131037) do

  create_table "posts", force: :cascade do |t|
    t.text "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
