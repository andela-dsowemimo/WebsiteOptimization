class Article < ActiveRecord::Base
  belongs_to :author, touch: true, counter_cache: true
  has_many :comments

  def self.all_names
    # all.map do |art|
    #   art.name
    # end
    select(:id, :name, :updated_at)
  end

  def self.five_longest_article_names
    # all.sort_by do |art|
    #   art.name
    # end.last(5).map do |art|
    #   art.name
    # end

    # @arr = all.pluck(:name)
    # @arr.sort!.last(5)

    order("LENGTH(name) DESC").limit(5).pluck(:name)
  end

  def self.articles_with_names_less_than_20_char
    # @arr = all.pluck(:name)
    # @arr.collect do |art|
    #   art.length < 20
    # end
    where("LENGTH(name) < 20").pluck(:name)
  end
end
