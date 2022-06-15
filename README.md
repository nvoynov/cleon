[![Gem Version](https://badge.fury.io/rb/cleon.svg)](https://badge.fury.io/rb/cleon) [![.github/workflows/main.yml](https://github.com/nvoynov/cleon/actions/workflows/main.yml/badge.svg)](https://github.com/nvoynov/cleon/actions/workflows/main.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/3395dba8f5c833532331/maintainability)](https://codeclimate.com/github/nvoynov/cleon/maintainability)

# Cleon

`Cleon` a set of basic PORO abstractions for building clean systems. If you are familiar with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), you'll catch everything at a glance. If not I doubted it serves to you. You may also check [User Stories](/user_stories.md).

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

You can check using those concepts in the [Users](https://github.com/nvoynov/cleon-users) demo gem that represents a simple but ubiquitous user management domain.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cleon'
```

And then execute:

    $ bundle install

## Usage

The first and foremost purpose of the Cleon is to provide a clean project skeleton. But once you have cloned the skeleton it forces you to follow Cleon's way during development. It is going to be mainly the creation of services and entities based on basic abstractions through creating and requiring source files mainly and that is quite boring.

To eliminate the source files routine, Cleon provides code generators for services, entities, and their tests. The generated sources have some commented code inside that reflects my current vision of how it will be utilized during development.

For instance, the most common way the service works is to request some data from the gateway, process it somehow, and then return the result of the processing; to test services at this stage of development, I am going to mock and stub the data gateway methods. All such suppositions are placed in the comments of generated services code.

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

arg = GuardString.("s") #  => 's'
arg = GuardString.(1)   # => ArgumentError: :string must be String
arg = GuardString.(1, 'name') # => ArgumentError: :name must be String
arg = GuardString.(1, 'name', 'should be String') # => ArgumentError: :name should be String
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

    GuardString = Demo::ArGuard.new('string', 'must be String',
      Proc.new {|v| raise "provide spec for GuardString file: #{__FILE__} line: #{__LINE__}"})

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

Once you need a new service you can run the following generator:

    $ cleon service SERVICE [PARAM1] [PRAM2]

The output will be

```
cleon service authenticate email secret
Create service...
  created lib/demo/services/authenticate.rb
  created lib/demo/services.rb~
  created lib/demo/services.rb
  created test/demo/services/authenticate_spec.rb
```

the "authenticate.rb" content

```ruby
require_relative '../basics/service'

module Demo
  module Services
    class Authenticate < Service
      def initialize(email:, secret:)
        @email = email
        @secret = secret
      end

      def call
        # gateway.authenticate(@email, @secret)
      end
    end
  end
end
```

the "authenticate_spec.rb" source

```ruby
require_relative '../../spec_helper'
include Demo::Services

describe Authenticate do

  let(:params) { {email:, secret:} }
  let(:service) { Authenticate }

  describe '#call' do
    it 'must return guarded result' do
      # @gateway = Minitest::Mock.new
      # @gateway.expect(:authenticate, nil, [String])
      #
      # Demo.stub :gateway, @gateway do
      #   result = service.(**params)
      #   assert GuardResult.(result), result
      # end
    end
  end
end
```

You can also enforce your service with argument guards.

    $ cleon service authenticate email:email secret:secret

Then generated service source will guard the service arguments:

```ruby
class Authenticate < Service
  def initialize(email:, secret:)
    @email = GuardEmail.(email)
    @secret = GuardSecret.(secret)
  end
  # skipped ..
end
```

### Creating a new entity

Once you need a new entity you can run the following:

    $ cleon entity ENTITY [PARA1] [PARA2]

The behavior is the same as for service generator

### Generating whole domains

If you like everything above, maybe [Dogen](https://github.com/nvoynov/dogen) could be your next step. `Dogen` provides a model for describing domains, a DSL for creating such models, and the domain generator that creates whole domain skeleton with guars, services and entities in the Cleon's way.

As the simplest case, you can just place a few Cleon's calls in a command-line scenario.

## Story

Once I caught myself copying and polishing basic classes from one project to another and then following DRY principle I just created the gem for this purpose. Somewhere in those time I had seen "The Foundation" series and chose the name after Cleon, because of his boring perpetuated constancy.

The first version actually just cloned the Cleon's source files directly from this gem to another location, and changing the name of the main gem module after. But then I created Dogen and migrated here generators.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cleon.
