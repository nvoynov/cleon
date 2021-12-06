# Cleon

`Cleon` a set of basic building blocks for building clean systems. If you are familiar with The Clean Architecture, you'll catch everything at a glance (entities, services, gateways, input ports, presenters). Just my `42` toward software construction and architecture questions :)

For demonstration purpose I also created demo [Users](__TODO__) domain and [Users REST Service](__TODO__)  in the form of a Sinatra web application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cleon'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cleon

## Usage

TODO: Write usage instructions here

## Story

Suddenly, after a decade of practicing business analysis in the software construction area, I've caught a surge to look deeper into modern "development" matters. The main points of curiosity are microservices, REST, event sourcing, and message broker stuff.

A few last weeks I was goofing around, some reading, encapsulating domain business logic in separate gems. Finally, I caught myself copying and polishing basic classes from one project to another and that is why I created the gem.

I had seen recently "The Foundation" series and chose the name taken after Cleon, because of his boring perpetuated constancy.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cleon.
