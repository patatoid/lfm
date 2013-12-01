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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131126111607) do

  create_table "1000_firsts_artists", :id => false, :force => true do |t|
    t.integer  "id",         :default => 0, :null => false
    t.string   "name"
    t.string   "mbid"
    t.integer  "listenings"
    t.string   "url"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "artist_edges", :id => false, :force => true do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.float   "weight"
  end

  add_index "artist_edges", ["child_id"], :name => "index_artist_edges_on_child_id"
  add_index "artist_edges", ["parent_id"], :name => "index_artist_edges_on_parent_id"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "mbid"
    t.integer  "listenings"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "visited"
  end

  add_index "artists", ["listenings"], :name => "index_artists_on_listenings"

end
