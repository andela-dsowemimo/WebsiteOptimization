class AuthorSweeper < ActionController::Caching::Sweeper
  observe Author

  def after_update(author)
    expire_cache_for(author)
  end

  def after_destroy(author)
    expire_cache_for(author)
    #expire cache for that page
    #expire cache for other pages after
  end

  def after_create(author)

  end
end
