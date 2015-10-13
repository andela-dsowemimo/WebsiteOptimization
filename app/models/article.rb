class Article < ActiveRecord::Base
  belongs_to :author, touch: true
  has_many :comments

  def self.all_names
    # all.map do |art|
    #   art.name
    # end
    @a = select(:name).all
  end

  def self.five_longest_article_names
    # all.sort_by do |art|
    #   art.name
    # end.last(5).map do |art|
    #   art.name
    # end
    @arr = all.pluck(:name)
    @arr.sort!.last(5)
  end

  def self.articles_with_names_less_than_20_char
    @arr = all.pluck(:name)
    @arr.collect do |art|
      art.length < 20
    end
  end
end
