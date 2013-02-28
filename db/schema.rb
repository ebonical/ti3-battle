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

ActiveRecord::Schema.define(:version => 20130226134909) do

  create_table "games", :force => true do |t|
    t.string   "token"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "games", ["name"], :name => "index_games_on_name"
  add_index "games", ["token"], :name => "index_games_on_token", :unique => true

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.string   "color"
    t.string   "race"
    t.text     "technologies"
    t.integer  "game_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "players", ["game_id"], :name => "index_players_on_game_id"
  add_index "players", ["number"], :name => "index_players_on_number"

end
