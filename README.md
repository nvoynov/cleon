[![Gem Version](https://badge.fury.io/rb/cleon.svg)](https://badge.fury.io/rb/cleon) [![.github/workflows/main.yml](https://github.com/nvoynov/cleon/actions/workflows/main.yml/badge.svg)](https://github.com/nvoynov/cleon/actions/workflows/main.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/3395dba8f5c833532331/maintainability)](https://codeclimate.com/github/nvoynov/cleon/maintainability)

# Cleon

```
-= Cleon v0.5.0 =- Clean Code Skeleton
home: https://github.com/nvoynov/cleon

Quickstart:
  1. gem "cleon" when your work with Bundler
  2. $ cleon

Commands:
  $ cleon CLONE
  $ cleon arguard NAME
  $ cleon service NAME [PARA1 PARA2]
  $ cleon entity NAME [PARA1 PARA2]
  $ cleon port CLEON PORT_TO
```

`Cleon` a set of basic PORO abstractions for building clean systems. If you are familiar with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), you'll catch everything at a glance. If not I doubted it serves to you. You may also check [User Stories](/user_stories.md).

You can check using those concepts in the [Users](https://github.com/nvoynov/cleon-users) demo gem that represents a simple but ubiquitous user management domain.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cleon'
```

And then execute:

    $ bundle install

## Usage

### Create the skeleton

Once you have decided to start a new ruby project for problem domain, you can start with creating a new gem and cloning Cleon skeleton to the gem. The following command exec `bundle gem CLONE` and then clone Cleon's code to the new generated gem; the `CLONE` parameter stands for the name of your new gem.

    $ cleon CLONE

Hope, the output of the command is clear

```
$ cleon demo
Clone myself to 'demo'...
Creating gem 'demo'...
# skipped bundler output
  created lib/demo/basics
  created lib/demo/services
  created lib/demo/entities
  created test/demo
  created test/demo/services
  created test/demo/entities
  created lib/demo/arguards.rb
  created lib/demo/basics.rb
  created lib/demo.rb~
  created lib/demo.rb
  created lib/demo/entities.rb
  created lib/demo/gateway.rb
  created lib/demo/services.rb
  created lib/demo/basics/arguard.rb
  created lib/demo/basics/service.rb
  created lib/demo/basics/entity.rb
Cleon was cloned successfully
```    

You need to fix `demo.gemspec` and then you can generate basic concepts. I know it's boring, but for me placing it to gem is important part.

### Creating a new arguard

I was brooding over adding some more advanced type system but finished with just simple as possible argument guard that just check and return value it if meets the guard spec.

The simple example of using guards is

```ruby
GuardString = ArGuard.new('string', 'must be String',
  Proc.new{|v| v.is_a?(String)})

arg = GuardString.("s")
#  => 's'
arg = GuardString.(1)
# => ArgumentError: :string must be String
arg = GuardString.(1, 'name')
# => ArgumentError: :name must be String
arg = GuardString.(1, 'name', 'should be String')
# => ArgumentError: :name should be String
```

To create a new guard just run the following command:

    $ cleon arguard string

That will create a blank for the guard and its test. The output demonstrates a general behavior of Cleon's generators. It generates source and source_spec, backup previous version of the source when it already exit in sources tree.

```
$ cleon arguard string
Create arguard 'string'...
  created lib/demo/arguards.rb~
  created lib/demo/arguards.rb
  created test/demo/arguards_spec.rb
  created test/demo/arguards_spec.rb~
  created test/demo/arguards_spec.rb
ArGuard was created successfully
```
arguards.rb

```ruby
require_relative 'basics/arguard'

module Demo
  # Place here shared argument guards for the domain
  module ArGuards

    GuardString = Demo::ArGuard.new(
      'string', 'must be String',
      Proc.new {|v|
        raise "provide spec for GuardString file: #{__FILE__} line: #{__LINE__}"})

  end
end
```

arguards_spec.rb

```ruby
require_relative '../spec_helper'
include Demo::ArGuards

module SharedGuardSpecs
  extend Minitest::Spec::DSL

  # spec must provided the following variables:
  #   let(:guard) { GuardName }
  #   let(:valid) { ["name", :name] }
  #   let(:wrong) { [nil, 1, Object.new]}

  it 'must return value' do
    valid.each{|v| assert_equal v, guard.(v)}
  end

  it 'must raise ArgumentError' do
    wrong.each{|w| assert_raises(ArgumentError) { guard.(w) }}
  end
end

describe GuardString do
  include SharedGuardSpecs

  let(:guard) { GuardString }
  let(:valid) { [nil, -1, 0, 1, "", "str", Object.new] }
  let(:wrong) { [nil, -1, 0, 1, "", "str", Object.new] }
end
```

### Creating a new service

Once you need a new entity you can run the following generator:

    $ cleon entity new_entity para1 para2

The output


### Creating a new entity

Once you need a new entity you can run the following generator:

    $ cleon entity new_entity para1 para2

The output

```
$ cleon entity credentials email secret
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

    $ cleon service service_name para1 para2

The behavior is similar to `cleon entity`.

### Argument Guard

There is one small thing that should be mentioned - Cleon::ArGuard class that provides some way of guarding arguments of entities and services against wrong values.

The simple example is

```ruby
GuardString = ArGuard.new('string', 'must be String',
  Proc.new{|v| v.is_a?(String)})

arg = GuardString.("s")
#  => 's'
arg = GuardString.(1)
# => ArgumentError: :arg must be String
arg = GuardString.(1, 'name')
# => ArgumentError: :name must be String
arg = GuardString.(1, 'name', 'should be String')
# => ArgumentError: :name should be String
```

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
