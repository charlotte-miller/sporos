# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130731050223) do

  create_table "admin_users", force: true do |t|
    t.string   "first_name",             limit: 60
    t.string   "last_name",              limit: 60
    t.integer  "user_id",                limit: 4
    t.string   "email",                  limit: 80,  default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "password_salt",          limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true, using: :btree
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true, using: :btree

  create_table "answers", force: true do |t|
    t.integer  "question_id",   limit: 4
    t.integer  "author_id",     limit: 4
    t.text     "text",          limit: 65535
    t.integer  "blocked_count", limit: 4,     default: 0
    t.integer  "stared_count",  limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["author_id"], name: "index_answers_on_author_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "block_requests", force: true do |t|
    t.integer  "admin_user_id", limit: 4
    t.integer  "user_id",       limit: 4,   null: false
    t.integer  "source_id",     limit: 4,   null: false
    t.string   "source_type",   limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "block_requests", ["source_id", "source_type"], name: "index_block_requests_on_source_id_and_source_type", using: :btree
  add_index "block_requests", ["user_id"], name: "index_block_requests_on_user_id", using: :btree

  create_table "churches", force: true do |t|
    t.string   "name",       limit: 100, null: false
    t.string   "homepage",   limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id",   limit: 4,                null: false
    t.integer  "user_id",    limit: 4,                null: false
    t.boolean  "is_public",  limit: 1, default: true
    t.integer  "role_level", limit: 4, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["group_id", "user_id"], name: "index_group_memberships_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_memberships", ["user_id", "is_public"], name: "index_group_memberships_on_user_id_and_is_public", using: :btree

  create_table "groups", force: true do |t|
    t.string   "state",            limit: 50,                   null: false
    t.string   "name",             limit: 255,                  null: false
    t.text     "description",      limit: 65535,                null: false
    t.boolean  "is_public",        limit: 1,     default: true
    t.integer  "meets_every_days", limit: 4,     default: 7
    t.integer  "meetings_count",   limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["state", "is_public"], name: "index_groups_on_state_and_is_public", using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "study_id",                limit: 4,                     null: false
    t.integer  "position",                limit: 4,     default: 0
    t.string   "title",                   limit: 255,                   null: false
    t.text     "description",             limit: 65535
    t.string   "author",                  limit: 255
    t.string   "backlink",                limit: 255
    t.string   "poster_img_file_name",    limit: 255
    t.string   "poster_img_content_type", limit: 255
    t.integer  "poster_img_file_size",    limit: 4
    t.datetime "poster_img_updated_at"
    t.string   "poster_img_original_url", limit: 255
    t.string   "poster_img_fingerprint",  limit: 255
    t.string   "video_file_name",         limit: 255
    t.string   "video_content_type",      limit: 255
    t.integer  "video_file_size",         limit: 4
    t.datetime "video_updated_at"
    t.string   "video_original_url",      limit: 255
    t.string   "video_fingerprint",       limit: 255
    t.string   "audio_file_name",         limit: 255
    t.string   "audio_content_type",      limit: 255
    t.integer  "audio_file_size",         limit: 4
    t.datetime "audio_updated_at"
    t.string   "audio_original_url",      limit: 255
    t.string   "audio_fingerprint",       limit: 255
    t.boolean  "machine_sorted",          limit: 1,     default: false
    t.integer  "duration",                limit: 4
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["backlink"], name: "index_lessons_on_backlink", using: :btree
  add_index "lessons", ["study_id", "position"], name: "index_lessons_on_study_id_and_position", using: :btree

  create_table "meetings", force: true do |t|
    t.integer  "group_id",   limit: 4,              null: false
    t.integer  "lesson_id",  limit: 4,              null: false
    t.integer  "position",   limit: 4,  default: 0, null: false
    t.string   "state",      limit: 50,             null: false
    t.datetime "date_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meetings", ["group_id", "position"], name: "index_meetings_on_group_id_and_position", using: :btree
  add_index "meetings", ["group_id", "state"], name: "index_meetings_on_group_id_and_state", using: :btree
  add_index "meetings", ["lesson_id"], name: "index_meetings_on_lesson_id", using: :btree

  create_table "podcasts", force: true do |t|
    t.integer  "church_id",    limit: 4,   null: false
    t.string   "title",        limit: 100
    t.string   "url",          limit: 255, null: false
    t.datetime "last_checked"
    t.datetime "last_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "podcasts", ["church_id"], name: "index_podcasts_on_church_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "user_id",       limit: 4,                 null: false
    t.integer  "admin_user_id", limit: 4
    t.integer  "source_id",     limit: 4,                 null: false
    t.string   "source_type",   limit: 255,               null: false
    t.text     "text",          limit: 65535
    t.integer  "answers_count", limit: 4,     default: 0
    t.integer  "blocked_count", limit: 4,     default: 0
    t.integer  "stared_count",  limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["source_id", "source_type"], name: "index_questions_on_source_id_and_source_type", using: :btree
  add_index "questions", ["stared_count", "answers_count"], name: "index_questions_on_stared_count_and_answers_count", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "stars", force: true do |t|
    t.integer  "user_id",     limit: 4,  null: false
    t.integer  "source_id",   limit: 4,  null: false
    t.string   "source_type", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stars", ["source_id", "source_type"], name: "index_stars_on_source_id_and_source_type", using: :btree
  add_index "stars", ["user_id"], name: "index_stars_on_user_id", using: :btree

  create_table "studies", force: true do |t|
    t.string   "slug",                    limit: 255,               null: false
    t.integer  "podcast_id",              limit: 4,                 null: false
    t.string   "title",                   limit: 255,               null: false
    t.text     "description",             limit: 65535
    t.text     "keywords",                limit: 65535
    t.string   "ref_link",                limit: 255
    t.string   "poster_img_file_name",    limit: 255
    t.string   "poster_img_content_type", limit: 255
    t.integer  "poster_img_file_size",    limit: 4
    t.datetime "poster_img_updated_at"
    t.string   "poster_img_original_url", limit: 255
    t.string   "poster_img_fingerprint",  limit: 255
    t.integer  "lessons_count",           limit: 4,     default: 0
    t.datetime "last_published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studies", ["last_published_at"], name: "index_studies_on_last_published_at", using: :btree
  add_index "studies", ["podcast_id", "last_published_at"], name: "index_studies_on_podcast_id_and_last_published_at", using: :btree
  add_index "studies", ["slug"], name: "index_studies_on_slug", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                 limit: 60
    t.string   "last_name",                  limit: 60
    t.string   "public_id",                  limit: 20
    t.string   "email",                      limit: 80,  default: "", null: false
    t.string   "encrypted_password",         limit: 255, default: "", null: false
    t.string   "password_salt",              limit: 255
    t.string   "reset_password_token",       limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",         limit: 255
    t.string   "last_sign_in_ip",            limit: 255
    t.string   "confirmation_token",         limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",          limit: 255
    t.integer  "failed_attempts",            limit: 4,   default: 0
    t.datetime "locked_at"
    t.string   "profile_image_file_name",    limit: 255
    t.string   "profile_image_content_type", limit: 255
    t.integer  "profile_image_file_size",    limit: 4
    t.datetime "profile_image_updated_at"
    t.string   "profile_image_fingerprint",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["public_id"], name: "index_users_on_public_id", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
