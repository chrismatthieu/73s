# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100903213727) do

  create_table "adverts", :force => true do |t|
    t.integer  "profile_id"
    t.text     "description"
    t.integer  "placement"
    t.string   "name"
    t.string   "content_type"
    t.binary   "data"
    t.datetime "startdate"
    t.datetime "enddate"
    t.string   "url"
    t.integer  "viewcount"
    t.integer  "clickcount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aprsupdates", :force => true do |t|
    t.datetime "published"
  end

  create_table "articles", :force => true do |t|
    t.integer  "product_id"
    t.string   "url"
    t.date     "publishdate"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["profile_id"], :name => "index_blogs_on_profile_id"

  create_table "categories", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string   "clubname"
    t.text     "clubdesc"
    t.string   "clubcountry"
    t.string   "clubstate"
    t.string   "clubcity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "cluburl"
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "profile_id"
    t.string   "commentable_type", :default => "",    :null => false
    t.integer  "commentable_id",                      :null => false
    t.integer  "is_denied",        :default => 0,     :null => false
    t.boolean  "is_reviewed",      :default => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["profile_id"], :name => "index_comments_on_profile_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.binary   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "contacts", :force => true do |t|
    t.string   "callsign"
    t.string   "name"
    t.string   "email"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "frequency"
    t.string   "signal"
    t.string   "event"
    t.text     "notes"
    t.datetime "contacttime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.datetime "confirmed"
    t.string   "confirmation_code", :limit => 40
    t.string   "address"
    t.string   "age"
    t.string   "arrl_sect"
    t.string   "band"
    t.string   "county"
    t.string   "continent"
    t.string   "contestid"
    t.string   "cqzone"
    t.string   "gridsquare"
    t.string   "iota"
    t.string   "ituzone"
    t.string   "mode"
    t.string   "wpxprefix"
    t.string   "propmode"
    t.string   "qslmessage"
    t.datetime "qslreceivedate"
    t.datetime "qslsentdate"
    t.string   "qth"
    t.string   "rstreceived"
    t.string   "rstsent"
    t.string   "rxpower"
    t.string   "satellitemode"
    t.string   "satellitename"
    t.string   "serialreceived"
    t.string   "serialsent"
    t.string   "tenten"
    t.datetime "timeoff"
    t.datetime "timeone"
    t.string   "txpower"
    t.string   "veprov"
    t.string   "dxcc"
    t.string   "comment"
    t.string   "qslreceived"
    t.string   "qslsent"
    t.string   "qslvia"
  end

  create_table "events", :force => true do |t|
    t.string   "eventname"
    t.text     "eventdesc"
    t.date     "eventdate"
    t.time     "starttime"
    t.time     "endtime"
    t.string   "eventcountry"
    t.string   "eventstate"
    t.string   "eventcity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  create_table "feed_items", :force => true do |t|
    t.boolean  "include_comments", :default => false, :null => false
    t.boolean  "is_public",        :default => false, :null => false
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["item_id", "item_type"], :name => "index_feed_items_on_item_id_and_item_type"

  create_table "feeds", :force => true do |t|
    t.integer "profile_id"
    t.integer "feed_item_id"
  end

  add_index "feeds", ["profile_id", "feed_item_id"], :name => "index_feeds_on_profile_id_and_feed_item_id"

  create_table "forum_posts", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_topics", :force => true do |t|
    t.string   "title",        :null => false
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "last_post_by"
    t.datetime "last_post_at"
    t.datetime "created_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "title",        :limit => 100, :null => false
    t.string   "description"
    t.integer  "last_post_by"
    t.datetime "last_post_at"
    t.datetime "created_at"
    t.integer  "position"
  end

  create_table "forums_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "forum_id"
  end

  create_table "friends", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invited_id"
    t.integer  "status",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["invited_id", "inviter_id"], :name => "index_friends_on_invited_id_and_inviter_id", :unique => true
  add_index "friends", ["inviter_id", "invited_id"], :name => "index_friends_on_inviter_id_and_invited_id", :unique => true

  create_table "gears", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.boolean  "forsale"
    t.float    "price"
    t.boolean  "active"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_rosters", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groupers", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "profile_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hambriefs", :force => true do |t|
    t.integer  "episode"
    t.string   "title"
    t.text     "description"
    t.text     "embedcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read",        :default => false, :null => false
  end

  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "photos", :force => true do |t|
    t.string   "caption",    :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "image"
  end

  add_index "photos", ["profile_id"], :name => "index_photos_on_profile_id"

  create_table "products", :force => true do |t|
    t.integer  "company_id"
    t.integer  "forum_id"
    t.string   "category"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.boolean  "dstar"
    t.boolean  "aprs"
    t.boolean  "computer"
    t.boolean  "vox"
    t.boolean  "fm"
    t.boolean  "cw"
    t.boolean  "ssb"
    t.boolean  "am"
    t.boolean  "head"
    t.boolean  "speaker"
    t.boolean  "preamp"
    t.boolean  "swr"
    t.boolean  "submersible"
    t.boolean  "widereceive"
    t.boolean  "cwtrainer"
    t.boolean  "gps"
    t.boolean  "barometer"
    t.boolean  "temperature"
    t.boolean  "dualband"
    t.boolean  "bluetooth"
    t.string   "minpower"
    t.string   "maxpower"
    t.string   "lowestband"
    t.string   "highestband"
    t.string   "memorychannels"
    t.string   "display"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "icon"
    t.string   "image"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "blog"
    t.string   "flickr"
    t.text     "about_me"
    t.string   "aim_name"
    t.string   "gtalk_name"
    t.string   "ichat_name"
    t.string   "icon"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.boolean  "is_active",        :default => false
    t.string   "youtube_username"
    t.string   "flickr_username"
    t.string   "twitter_name"
    t.boolean  "aprs",             :default => false
    t.string   "skype_name"
    t.boolean  "supresssummary",   :default => false
    t.string   "irc_name"
    t.string   "echolink_name"
    t.string   "aprs_suffix"
    t.string   "twitter_pass"
    t.string   "irlp_name"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rating",                       :default => 0,  :null => false
    t.datetime "timestamp"
    t.integer  "profile_id",                   :default => 0,  :null => false
    t.string   "controllername", :limit => 25, :default => "", :null => false
    t.integer  "controllerid",                 :default => 0,  :null => false
  end

  create_table "repeaters", :force => true do |t|
    t.string   "trustee"
    t.string   "frequency"
    t.string   "long"
    t.string   "lat"
    t.string   "city"
    t.string   "state"
    t.string   "range"
    t.string   "offset"
    t.string   "pl"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "profile_id",    :default => 0,    :null => false
    t.string   "title",         :default => "",   :null => false
    t.text     "body",                            :null => false
    t.float    "rating"
    t.datetime "timestamp"
    t.integer  "thumbsup",      :default => 0
    t.integer  "thumbsdown",    :default => 0
    t.boolean  "emailcomments", :default => true, :null => false
    t.integer  "viewcount",     :default => 0,    :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "statuses", :force => true do |t|
    t.integer  "profile_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "privatemsg", :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "is_admin"
    t.boolean  "can_send_messages",                       :default => true
    t.string   "time_zone",                               :default => "UTC"
    t.string   "email_verification"
    t.boolean  "email_verified"
    t.string   "status"
    t.datetime "last_active"
    t.integer  "twitter_id"
    t.string   "access_token"
    t.string   "access_secret"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
