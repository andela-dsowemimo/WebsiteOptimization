class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article

  def after_update(article)
    expire_cache_for(article)
  end

  def after_destroy(article)
    expire_cache_for(article)
  end

end
