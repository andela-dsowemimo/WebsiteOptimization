class Article < ActiveRecord::Base
  belongs_to :author, touch: true, counter_cache: true
  has_many :comments

  def self.all_names
    select(:id, :name, :updated_at)
  end

  def self.five_longest_article_names
    order("LENGTH(name) DESC").limit(5).pluck(:name)
  end

  def self.articles_with_names_less_than_20_char
    where("LENGTH(name) < 20").pluck(:name)
  end

  def self.with_most_upvotes_belongs_to_this_author
    order("upvotes DESC").first.author.name
  end
end
