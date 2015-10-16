class AuthorSweeper < ActionController::Caching::Sweeper
  observe Author

  def after_update(author)
    expire_cache_for(author)
  end

  def after_destroy(author)
    expire_cache_for(author)
  end
end
