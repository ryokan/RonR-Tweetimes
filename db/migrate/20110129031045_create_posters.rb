class CreatePosters < ActiveRecord::Migration
  def self.up
    create_table :posters do |t|
      t.string :user
      t.string :query
      t.text :result

      t.timestamps
    end
  end

  def self.down
    drop_table :posters
  end
end
