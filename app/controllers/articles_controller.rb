class ArticlesController < ApplicationController
  def show
    @article = Article.includes(:comments).find(params["format"])
  end
end
