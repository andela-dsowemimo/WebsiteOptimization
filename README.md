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
Replacing code like
```ruby
def self.most_prolific_writer
  all.sort_by{|a| a.articles.count }.last
end

def self.most_prolific_writer
  order("articles_count").last
end

```

##### Index some columns. But what should we index?

[great explanation of how to index columns and when](http://tutorials.jumpstartlab.com/topics/performance/queries.html#indices)

Our non-performant app has many opportunities to index. Just look at our associations. There are many foreign keys in our database...

```ruby
class Article < ActiveRecord::Base
  belongs_to :author
  has_many :comments
end
```

##### Ruby vs ActiveRecord

Let's try to get some ids from our Article model.

Look at Ruby:

```ruby
puts Benchmark.measure {Article.select(:id).collect{|a| a.id}}
  Article Load (2.6ms)  SELECT "articles"."id" FROM "articles"
  0.020000   0.000000   0.020000 (  0.021821)
```

The real time is 0.021821 for the Ruby query.

vs ActiveRecord

```ruby
puts Benchmark.measure {Article.pluck(:id)}
   (3.2ms)  SELECT "articles"."id" FROM "articles"
  0.000000   0.000000   0.000000 (  0.006992)
```
The real time is 0.006992 for the AR query. Ruby is about 300% slower.

For example, this code is terribly written in the Author model:

```ruby
def self.most_prolific_writer
  all.sort_by{|a| a.articles.count }.last
end

def self.with_most_upvoted_article
  all.sort_by do |auth|
    auth.articles.sort_by do |art|
      art.upvotes
    end.last
  end.last
end
```

Both methods use Ruby methods (sort_by) instead of ActiveRecord. Let's fix that.

##### html_safe makes it unsafe or safe?.

This is why variable and method naming is important.

In the show.html.erb for articles, we have this code

```ruby
  <% @articles.comments.each do |com| % >
    <%= com.body.html_safe %>
  <% end %>
```

What's wrong with it?

The danger is if comment body are user-generated input...which they are.

See [here](http://stackoverflow.com/questions/4251284/raw-vs-html-safe-vs-h-to-unescape-html)

Understand now? Fix the problem.


##### Caching

Our main view currently takes 4 seconds to load

```bash
Rendered author/index.html.erb within layouts/application (5251.7ms)
Completed 200 OK in 5269ms (Views: 4313.1ms | ActiveRecord: 955.6ms)
```

Let's fix that. Read this:
[fragment caching](http://guides.rubyonrails.org/caching_with_rails.html#fragment-caching)
