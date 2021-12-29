[![Gem Version](https://badge.fury.io/rb/cleon.svg)](https://badge.fury.io/rb/cleon) [![.github/workflows/main.yml](https://github.com/nvoynov/cleon/actions/workflows/main.yml/badge.svg)](https://github.com/nvoynov/cleon/actions/workflows/main.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/3395dba8f5c833532331/maintainability)](https://codeclimate.com/github/nvoynov/cleon/maintainability)

# Cleon

`Cleon` a set of basic PORO abstractions for building clean systems. If you are familiar with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), you'll catch everything at a glance. If not I doubted it serves to you. Just entities, services (interactors or use cases), and gateways at the moment.

You can check using those concepts in demo gem [Users](https://github.com/nvoynov/cleon-users) that represents a simple but ubiquitous user management domain.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cleon'
```

And then execute:

    $ bundle install

## Usage

### Copying basic abstractions

Once you have started with a new gem, just run the code in your console to create source files for Cleon's abstractions:

    $ cleon clone

It also will copy `cleon.thor` file into the root directory, so further you can install Thor and use just this file; or create your own Rake tasks.

### Creating a new entity

Once you need to create a new entity you can run:

    $ ruby -e 'require "cleon"; Cleon.clone_entity "new_entity para1 para2"'

or

    $ thor cleon:entity new_entity para1 para2

Let's create one and see the results

```
thor cleon:entity credentials email secret
Cleon: clone entity...
  created lib/dogen/entities/credentials.rb
  created test/dogen/entities/credentials_spec.rb
```

lib/dogen/entities/credentials.rb

```ruby
require_relative 'entity'

module Dogen
  module Entities

    class Credentials < Entity

      attr_reader :email
      attr_reader :secret

      def initialize(email:, secret:)
        @email = email
        @secret = secret
      end

    end

  end
end
```

test/dogen/entities/credentials_spec.rb

```ruby
require_relative '../../spec_helper'
include Dogen::Entities

describe Credentials do

  # let(:entity) { Credentials }.new(email:, secret:)

  it 'must do something' do
  end

end
```

### Creating a new service

Once you need to create a new service you can run:

    $ ruby -e 'require "cleon"; Cleon.clone_service "service_name para1 para2"'

or

    $ thor cleon:entity service_name para1 para2

The behavior is similar to `Cleon.clone_entity`.

### Generating whole domains

If you like everything above, maybe [Dogen](https://github.com/nvoynov/dogen) could be your next step. `Dogen` develops Cleon's ideas and proposes a model for describing domains, a DSL for creating such models, and a generator for creating a Ruby skeleton of such models along the way of Cleon.

## Story

A few last weeks I was goofing around, some reading, encapsulating domain business logic in separate gems. Finally, I caught myself copying and polishing basic classes from one project to another and that is why I created the gem.

I had seen recently "The Foundation" series and chose the name taken after Cleon, because of his boring perpetuated constancy.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cleon.
