class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :author
      t.string :authorurl
      t.string :url
      t.string :date
      t.string :content
      t.string :image
      t.string :poster_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
