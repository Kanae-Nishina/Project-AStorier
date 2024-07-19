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

ActiveRecord::Schema[7.1].define(version: 2024_07_19_124851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_uuid", null: false
    t.index ["user_uuid"], name: "index_authentications_on_user_uuid"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.uuid "user_uuid", null: false
    t.uuid "post_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_uuid", "post_uuid"], name: "index_bookmarks_on_user_uuid_and_post_uuid", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "text", default: "", null: false
    t.uuid "user_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_uuid", null: false
    t.uuid "post_uuid", null: false
    t.index ["post_uuid"], name: "index_favorites_on_post_uuid"
    t.index ["user_uuid"], name: "index_favorites_on_user_uuid"
  end

  create_table "illust_attachments", force: :cascade do |t|
    t.bigint "illust_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["illust_id"], name: "index_illust_attachments_on_illust_id"
  end

  create_table "illusts", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.uuid "user_uuid", null: false
    t.integer "link_kind", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_uuid", "link_kind", "content"], name: "index_links_on_user_uuid_and_link_kind_and_content", unique: true
  end

  create_table "notices", force: :cascade do |t|
    t.boolean "favorite", default: false, null: false
    t.boolean "bookmark", default: false, null: false
    t.boolean "comment", default: false, null: false
    t.boolean "follower", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.uuid "post_uuid", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_post_comments_on_comment_id"
  end

  create_table "post_game_systems", force: :cascade do |t|
    t.integer "game_system_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "post_uuid", null: false
    t.index ["post_uuid"], name: "index_post_game_systems_on_post_uuid"
  end

  create_table "post_synalios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "synalio_id", null: false
    t.uuid "post_uuid", null: false
    t.index ["synalio_id"], name: "index_post_synalios_on_synalio_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tag_id"
    t.uuid "post_uuid", null: false
    t.index ["post_uuid"], name: "index_post_tags_on_post_uuid"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", primary_key: "uuid", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "caption"
    t.integer "publish_state"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postable_type", null: false
    t.bigint "postable_id", null: false
    t.uuid "user_uuid", null: false
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable"
    t.index ["user_uuid"], name: "index_posts_on_user_uuid"
    t.index ["uuid"], name: "index_posts_on_uuid", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_uuid", null: false
    t.index ["user_uuid"], name: "index_profiles_on_user_uuid"
  end

  create_table "relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "follower_uuid", null: false
    t.uuid "followed_uuid", null: false
    t.index ["followed_uuid"], name: "index_relationships_on_followed_uuid"
    t.index ["follower_uuid"], name: "index_relationships_on_follower_uuid"
  end

  create_table "synalios", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_synalios_on_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notices", force: :cascade do |t|
    t.integer "notice_kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "notice_id"
    t.uuid "user_uuid", null: false
    t.index ["notice_id"], name: "index_user_notices_on_notice_id"
    t.index ["user_uuid"], name: "index_user_notices_on_user_uuid"
  end

  create_table "users", primary_key: "uuid", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "email"
    t.integer "role", default: 0
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_sent_at"], name: "index_users_on_reset_password_sent_at", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authentications", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "bookmarks", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "bookmarks", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "comments", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "favorites", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "favorites", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "illust_attachments", "illusts"
  add_foreign_key "links", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "post_comments", "comments"
  add_foreign_key "post_comments", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "post_game_systems", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "post_synalios", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "post_synalios", "synalios"
  add_foreign_key "post_tags", "posts", column: "post_uuid", primary_key: "uuid"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "profiles", "users", column: "user_uuid", primary_key: "uuid"
  add_foreign_key "relationships", "users", column: "followed_uuid", primary_key: "uuid"
  add_foreign_key "relationships", "users", column: "follower_uuid", primary_key: "uuid"
  add_foreign_key "user_notices", "notices"
  add_foreign_key "user_notices", "users", column: "user_uuid", primary_key: "uuid"
end
