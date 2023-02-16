# Design decisions

## Choice of libraries

**Testing framework**: [RSpec](https://rspec.info/) -
**HTTP client**: [HTTPParty](https://github.com/jnunemaker/httparty) - Who doesn't like to party? :tada: :tada: :tada: Just kidding, I chose this because it's simple and easy to use. I considered [Faraday](https://lostisland.github.io/faraday/) but I just needed a library that can do simple http requests, nothing fancy and easier to use than `Net::HTTP`.

I chose VCR for recording and replaying HTTP responses and Webmock for stubbing HTTP requests and responses.

## Making requests

I thought about going with a class-based approach for getting info about resources from the API. for example:

```ruby
require 'lotr'

# List all movies
Lotr::Movie.all

# Retrieve a movie
Lotr::Movie.find("5cd95395de30eff6ebccde5b")

# List all movie quotes for one specific movie
Lotr::Movie.find("5cd95395de30eff6ebccde5b").quotes

# Paginate movie quotes
Lotr::Movie.find("5cd95395de30eff6ebccde5b").quotes(page: 2, limit: 5)

# Sort movie quotes, sort by character asc
Lotr::Movie.find("5cd95395de30eff6ebccde5b").quotes(sort: 'character', order: 'asc')

```

I love the readability of this approach but I figured this might be time consuming in terms of writing the implementation, error handling, testing, etc. Also this closely mirrors how [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html#read) models work which might be confusing to some users who might think we are retrieving results from a local datastore.

So I went with a simpler approach, where API calls are available as instance methods of a single class.

```ruby
require 'lotr'

# Initialize the client and provide authentication credentials
client = Lotr::Client.new(api_key: 'your_api_key')

# List all movies
client.movies
```

Also provided alias methods for the API endpoints:

```ruby
# List all movies
client.get_movies # same client.movies
```

## Accessing resources

At the moment The One API endpoints return a JSON response where `docs` is an array of objects whether we are fetching a single resource (`/movies/:id`) or a collection (`/movies`):

```json
{
  "docs": [
    {
      "_id": "5cd95395de30eff6ebccde5b",
      "name": "The Two Towers",
      "runtimeInMinutes": 179,
      "budgetInMillions": 94,
      "boxOfficeRevenueInMillions": 342,
      "academyAwardNominations": 7,
      "academyAwardWins": 2,
      "rottenTomatoesScore": 89
    }
  ],
  "total": 1,
  "limit": 10,
  "page": 1,
  "pages": 1
}
```

This looks like anti-pattern to me. I think it would be better if the API returned a single object for single resources and an array of objects for collections. This would make it easier for the client to consume the API. I also don't undertstand why the API returns a `docs`, `page`, `pages`, `limit` and `total` fields, especially for single resources.

In my opinion SDKs should follow the language's conventions and idioms and also make it easier for the application developer to consume the API. So, I decided to return an `OpenStruct` object for single resources and an array of `OpenStruct` objects for collections and transformed the keys from `camelCase` to `snake_case` so that users can access the data using dot notation or [] for fields returned in the API response e.g:

```ruby
movie = client.movie("5cd95395de30eff6ebccde5b")
puts movie['name']
# => "The Two Towers"
puts movie[:academy_award_wins]
# => 2
puts movie.runtime_in_minutes
# => 179
```

With that being said, I think we can also give the user an option to access the raw response from the API. This would be useful for debugging and for users who want to access the `docs`, `page`, `pages`, `limit` and `total` fields. This can be done by providing the following methods inside the `Lotr::Client` class:

```ruby
movie = client.movie("5cd95395de30eff6ebccde5b")
response  = client.last_response # returns the last HTTP response where the movie was being fetched
headers   = response.headers
body      = response.body
```

I didn't get around to doing this. This can be done in a future release.

## Configuring the client

I wanted to enhance how we can configure this SDK by using configuration block. I noticed this pattern with the Airbrake gem and really liked it:

I liked the way Airbrake did it and wanted to implement the same pattern:

```ruby
Lotr.configure do |config|
  config.api_key = 'frodo_was_here'
  config.api_version = 'v2' # In case of future API versions or if you want to use v1
  config.auto_paginate = true # enable auto pagination
  config.per_page = 10 # Default number of results per page for paginated endpoints
end
```

Clean internal implementation and easy for the application developer to understand. This could be used in `config/initializers/lotr.rb` in a Rails app and gives our users multiple options for configuring the SDK.

I decided to go with a simpler approach for now and just allow the user to pass in the API key as an argument to the `Lotr::Client` constructor.

```ruby
client = Lotr::Client.new(api_key: 'easy_peasy')
```

## Some other stuff I'd like to add (If I had more time)

- Implement sorting for `/movie` and `/quote` endpoints but it doesn't seem to be supported by the API
- fetching API key from local .env file using [dotenv](https://github.com/bkeepers/dotenv) gem.
