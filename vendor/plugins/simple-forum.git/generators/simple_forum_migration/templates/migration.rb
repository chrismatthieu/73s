class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table "forums", :force => true do |t|
      t.string :title, :limit => 100, :null => false
      t.string :description, :limit => 255, :null => true
      t.integer :last_post_by
      t.datetime :last_post_at, :created_at
    end

    create_table :forum_topics, :force => true do |t|
      t.string :title, :null => false
      t.references :forum
      t.references :user
      t.integer :last_post_by
      t.datetime :last_post_at, :created_at
    end

    create_table :forum_posts, :force => true do |t|
      t.text :body, :null => false
      t.references :topic
      t.references :user
      t.timestamps
    end

    create_table :forums_users, :force => true, :id => false do |t|
      t.references :user
      t.references :forum
    end
  end

  def self.down
    drop_table :forums
    drop_table :forum_topics
    drop_table :forum_posts
    drop_table :forums_moderators
  end
end
