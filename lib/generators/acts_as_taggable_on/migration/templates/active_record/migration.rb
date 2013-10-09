class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :taggable_tags do |t|
      t.string :name
    end

    create_table :taggable_taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, :limit => 128

      t.datetime :created_at
    end

    add_index :taggable_taggings, :tag_id
    add_index :taggable_taggings, [:taggable_id, :taggable_type, :context], :name => 'taggable_index'
  end

  def self.down
    drop_table :taggable_taggings
    drop_table :taggable_tags
  end
end
