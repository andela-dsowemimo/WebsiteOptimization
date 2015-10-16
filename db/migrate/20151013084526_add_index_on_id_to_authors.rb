class AddIndexOnIdToAuthors < ActiveRecord::Migration
  def change
    add_index :authors, :id
  end
end
