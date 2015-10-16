# Website Optimization

Retrieving data can sometimes be expensive. If this retrieval process is not handled properly it can lead to slow and very long load times which can lead to bad user experience.
This project aims to improve the data retrieval and various load times of a poorly designed website using caching, indexing, efficient queries and techniques.

### This is one of the worst performing Rails apps ever.

Currently, the home page takes this long to load:

```bash
...
Article Load (0.5ms)  SELECT "articles".* FROM "articles" WHERE "articles"."author_id" = ?  [["author_id", 3000]]
Article Load (0.5ms)  SELECT "articles".* FROM "articles" WHERE "articles"."author_id" = ?  [["author_id", 3001]]
Rendered author/index.html.erb within layouts/application (9615.5ms)
Completed 200 OK in 9793ms (Views: 7236.5ms | ActiveRecord: 2550.1ms)
```

The view takes 7.2 seconds to load. The AR querying takes 2.5 second to load. The page takes close to 10 seconds to load. That's not great at all. That's just awful.

The stats page is even worse:

```bash
Rendered stats/index.html.erb within layouts/application (9.9ms)
Completed 200 OK in 16197ms (Views: 38.0ms | ActiveRecord: 4389.4ms)
```

It took 16 seconds to load and a lot of the time taken isn't even in the ActiveRecord querying or the view. It's the creation of ruby objects that is taking a lot of time.

Thsi can be improved by replacing ruby methods with ActiveRecord querying
Replacing code like this
```ruby
def self.most_prolific_writer
  all.sort_by{|a| a.articles.count }.last
end
```
With code like this
```ruby
def self.most_prolific_writer
  order("articles_count").last
end

```

##### Index some columns.

Our non-performant app has many opportunities to index. Just look at our associations. By adding index to some columns that are used for searches it makes searched faster. Adding index to the author ID makes it easy to search for authors.

```ruby
class AddIndexOnIdToAuthors < ActiveRecord::Migration
  def change
    add_index :authors, :id
  end
end
```

##### Caching and Sweepers

Our main view currently takes 4 seconds to load. This is because making database calls can be quite expensive especially when dealing with a lot of data. This is bad for performance.

```bash
Rendered author/index.html.erb within layouts/application (5251.7ms)
Completed 200 OK in 5269ms (Views: 4313.1ms | ActiveRecord: 955.6ms)
```

We can improve on this by using caching, which will serve as an alternative to making these expensive database calls.
```ruby
<% cache author do %>
  <h3 class="center_text">My name is <%= author.name %></h3>
  <p class="center_text">Articles written by me</p>
  <% author.articles.each do |article| %>
    <p class="center_text"><span style="text-decoration: underline"><%= link_to article.name, "articles/#{article.id}" %> </span></p>
  <% end %>
<% end %>
```


Using Sweepers, we can observe the states of an object for a change to expire a cache.
```ruby
class AuthorSweeper < ActionController::Caching::Sweeper
  observe Author

  def after_update(author)
    expire_cache_for(author)
  end

  def after_destroy(author)
    expire_cache_for(author)
  end
end
```

The site can be viewed [Here](https://enigmatic-woodland-7776.herokuapp.com/)

#Copyright

Copyright (c) 2015, Daisi Sowemimo, Andela
