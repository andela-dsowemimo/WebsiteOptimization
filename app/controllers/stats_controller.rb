class StatsController < ApplicationController
  def index
    @five_longest_article_names = Article.five_longest_article_names
    @prolific_author = Author.most_prolific_writer
    @author_with_most_upvoted_article = Article.with_most_upvotes_belongs_to_this_author
    @article_names = Article.page(params[:page]).all_names.per(30)
    @short_articles = Article.articles_with_names_less_than_20_char
  end
end
