# WARNING!

This library is under active development and is not ready for use in production apps. There are bugs. Use at your own risk (but please report the bugs and help fix them).

# Motion::Rest

Motion::Rest is a framework for RubyMotion for modeling your remote data in way that feels similar to ActiveRecord.

```ruby
class Post
  include Motion::Rest::Resource

  attributes :title, :body
  attribute :created_at, type: :datetime
  attribute :published, type: :boolean

  belongs_to :author, class: User
  has_many :comments
end
```

Motion::Rest supports multiple API schemas through serialization/deserialization adapters. This allows you to support any number of API schemas (including the jsonapi.org spec), by simply changing the adapter that is used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'motion-rest', github: 'andrewhavens/motion-rest'
```

And then execute:

    $ bundle

## Usage

### Configuration
If you are working with a single API, you can configure Motion::Rest to use a set of defaults. To configure Motion::Rest, specify a `configure` block in your App Delegate, or a separate file that will get loaded by RubyMotion. You can use this to specify the base URI of your API, or specify the default serialization format. Motion::Rest defaults to the format that Rails uses when you call `to_json` on a model. We named this adapter `:flat` because of how the attributes and relationships are all one level.

```ruby
Motion::Rest.configure do |config|
  config.base_uri = "https://api.example.com/v1"
  config.serializer = :flat # or :json_api
end
```

These settings may also be configured on an individual model basis, in the case of irregular models, or multiple APIs.

### Supported Adapters
#### `:flat`
Example schema:
```ruby
[
  {
    id: 1,
    title: "foo",
    body: "bar",
    author_id: 123
  }
]
```

#### `:json_api`
Example schema:
```ruby
{
  data: [
    {
      type: "posts",
      id: 1,
      attributes: {
        title: "foo",
        body: "bar",
      },
      relationships: {
        author: {
          data: {
            type: "users",
            id: 123
          }
        }
      }
    }
  ]
}
```

### Creating Models

Typically, you will put your models in your `app/models` directory, and include the `Motion::Rest::Resource` mixin:

```ruby
# app/models/post.rb
class Post
  include Motion::Rest::Resource
end
```

#### Defining Attributes

To define attributes, you can either define them one at a time if you need to specify additional options, or list them all if they are all simple strings. For example:

```ruby
class Post
  include Motion::Rest::Resource

  # All string or integer attributes with no options.
  attributes :title, :body, :image_url

  # A single attribute, marked as read only so that it is not included in
  # create/update requests.
  attribute :comments_count, read_only: true

  # Specify the type of object that will be returned.
  attribute :published, type: :boolean, default: false
  attribute :created_at, type: :date, read_only: true
end
```

#### Defining Associations

There are three types of associations that Motion::Rest supports: `has_one`, `belongs_to`, and `has_many`. Each association accepts a `class_name` and/or `read_only` options.

```ruby
class Post
  include Motion::Rest::Resource

  # A simple association where the class name can be assumed from the name of the association.
  has_many :comments

  # An association that has a different name than the type of class that it uses.
  # Also marked as read only, so that it can only be changed on the server side.
  belongs_to :author, class_name: "User", read_only: true
end
```

#### CRUD: Create, Read, Update, Delete

By default, Motion::Rest models provide the following methods, and their corresponding API requests, prefixed with the default base URI:

* `Post.all` - `GET /posts`
* `Post.find` - `GET /posts/:id`
* `Post.create` - `POST /posts`
* `Post#save` - `POST /posts` or `PUT /posts/:id` if the instance already has an id
* `Post#update` - `PUT /posts/:id`
* `Post#destroy` - `DELETE /posts/:id`

All of these methods accept a block which is called when the asynchronous HTTP request has completed. The first argument to the block is the response object. The second argument is an array or instance of the model (assuming the response was successful). For example:

```ruby
Post.all do |response, posts|
  if response.success?
    @posts = posts # posts is an array of Post models
    update_table_data
  else
    app.alert "Sorry there was an error fetching the posts."
    # posts would be nil
    NSLog response.error.localizedDescription
  end
end
```

Chaining onto associations will include the parent resource in the request so that you can request nested resources. For example:

```ruby
# Assuming this instance of post has an id of 123, this request calls:
# POST /posts/123/comments
post.comments.create(body: "Hello world") do |response, comment|
  puts comment.id # 456
  puts comment.body # "Hello world"
end
```

#### Custom Endpoints

Sometimes you have a non-standard endpoint that just doesn't behave like the others. Or maybe you need to work with an API that is totally different than your primary API. You can override the base URI, serialization adapter, root key, collection URI, or resource URI within the model:

```ruby
class Tweet
  include Motion::Rest::Resource
  http_client TwitterApiClient
  base_uri "https://api.twitter.com/1.1"
  serializer :flat_with_embedded_associations
  root_key "statuses"
  collection_uri "search/tweets.json"
  resource_uri { "statuses/show/#{id}.json" }

  attributes :text, :retweet_count
  belongs_to :user

  def self.search(search_term, &callback)
    # Reuse the all method since it already makes a GET request to the collection URI
    all(q: search_term, &callback)
  end
end

TwitterApiClient.authenticate # ...
Tweet.search "RubyMotion" do |response, tweets|
  # ...
end
```

## Questions?

Still have questions? Please submit an issue so that we can improve the documentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andrewhavens/motion-rest.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
