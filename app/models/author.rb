class Author < ActiveRecord::Base

  has_many :articles

  default_scope { includes(:articles) }

  def self.generate_authors(count=1000)
    count.times do
      Fabricate(:author)
    end
    first.articles << Article.create(name: "some commenter", body: "some body")
  end

  def self.most_prolific_writer
    order("articles_count").last
  end

  def self.with_most_upvoted_article
    all.sort_by do |auth|
      auth.articles.sort_by do |art|
        art.upvotes
      end.last
    end.last.name
    # order("upvotes").last.name
  end
  #
  # def expire_author(author)
  #   expire_cache_for(author)
  # end
  #
  # def expire_page
  #   expire_fragment("all-authors-page-#{page_number}")
  # end
end
