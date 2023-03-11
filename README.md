# Lotr

Ruby SDK for the [The Lord of the Rings API](https://the-one-api.dev/).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add lotr

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install lotr

## Usage

### Making requests

```ruby
require 'lotr'

# Initialize the client and provide authentication credentials
client = Lotr::Client.new(api_key: 'your_api_key')

# List all movies
client.movies # or client.get_movies

# Retrieve a movie
client.movie("5cd95395de30eff6ebccde5b") # or client.get_movie("5cd95395de30eff6ebccde5b")

# List all movie quotes for one specific movie
client.quotes_for_movie("5cd95395de30eff6ebccde5b") # or client.get_quotes_for_movie("5cd95395de30eff6ebccde5b")
```

### Additional query parameters

```ruby
# Paginate movie quotes
client.quotes_for_movie("5cd95395de30eff6ebccde5b", page: 2, limit: 5)

# Sort movie quotes, sort by character asc
client.quotes_for_movie("5cd95395de30eff6ebccde5b", sort: 'dialog', order: 'asc')
```

### Consuming resources

The API methods return a Resource open struct object which provides dot notation and [] access for fields returned in the API response e.g.

```ruby
movie = client.movie("5cd95395de30eff6ebccde5b")
puts movie['name']
# => "The Two Towers"
puts movie[:academy_award_wins]
# => 2
puts movie.runtime_in_minutes
# => 179
```

### Error handling

The API methods raise an error if the API returns an error response. The error object is a subclass of `Lotr::Error` e.g:

```ruby
client = Lotr::Client.new(api_key: "invalidAPKey")
begin
  client.movies
# handle specific errors
rescue Lotr::Unauthorized => e
  puts e.message
  # => "Unauthorized"
rescue Lotr::Error => e
  # could be any other error e.g. Lotr::Unauthorized, Lotr::Forbidden, Lotr::BadRequest, Lotr::InternalServerError, Lotr::ServiceUnavailable
  # or any other error that might be raised by the underlying HTTP client.

  # log the error, notify user, retry the request, etc.
end
```

### Design

See [design.md](https://github.com/FawazFarid/lotr/blob/main/design.md) for more details on the design of the SDK.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FawazFarid/lotr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/https://github.com/FawazFarid/lotr/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lotr project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/FawazFarid/lotr/blob/main/CODE_OF_CONDUCT.md).
