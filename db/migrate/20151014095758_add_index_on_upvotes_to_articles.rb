class AddIndexOnUpvotesToArticles < ActiveRecord::Migration
  def change
    add_index :articles, :upvotes
  end
end
