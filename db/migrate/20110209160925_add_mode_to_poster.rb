class AddModeToPoster < ActiveRecord::Migration
  def self.up
    add_column :posters, :mode, :string
    add_column :posters, :code, :integer
  end

  def self.down
    remove_column :posters, :code
    remove_column :posters, :mode
  end
end
