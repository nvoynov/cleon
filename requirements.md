% Cleon Requirements

TODO:

- split into us, fr, cli in `doc/req` folder and anounce clerq?

# User Stories

## Clean code structure
{{id: us.struct}}

As a dev, I want to hold my code "clean" and "user-oriented", so it will be easy to write, read, and evolve in the future.

To achieve this I'm going to design my code according to The Clean Architecture principles. At the core level, I'm going to have just three concepts - services (algorithms, use cases, interactors), entities (data structures), and abstract gateway. Going further, I want the ability to create ports for all the domain services

## Create "clean" skeleton
{{id: us.create.skeleton}}

As a dev, when I start a new project, I want to create the "clean" skeleton of the project packed in Ruby gem, so that I'll get the code of the core concepts of services and entities necessary to evolve the project ideas from.

### Create a new "clean"
{{id: us.create.gem}}

When I do not have the gem for the project, I want to create a new gem for it.

### Copy "clean" structure
{{id: us.clone.skeleton}}

__UNDER CONSTRUCTION__ just cloning Cleon into an existing gem seemed a perfect idea at the beginning, but the more I'm brooding in terms of "generators" the more I reckon that straight and natural behavior will be just creating a new gem and populating it by Cleon's structure and concepts.

When I have the gem for the project already, I want just to copy or clone the "clean" structure and core concepts to the existing gem.

## Basic toolbox

### Create and require
{{id: us.create.concept}}

As a dev, when I work on a certain project, I want to have some basic tools which will help me with tasks that are quite boring, like creating and requiring source files for services and entities, so it'll eliminate distraction on right code structuring.

### Port services
{{id: us.port.services}}

When I have stable calling interfaces of my services, I want to port those services to use in different scopes like API or client libraries, so it will help me with creating this scope.

### Port from other sources
{{id: us.port.services.from}}

When I develop the domain and its interface in a separate gem, I want to have the ability to port the domain services from the domain's gem to the interface's gem, that way I can easily port different domain services into a separate client library or API.

# Functional Requirements

## Clean Structure
{{id: fr.structure}}

The system shall provide the structure of the following concepts:

{{@@list}}

For supposed gem with name `clone`, the project files structure inside the `clone` directory must be as following:

- `clone.gemspec`
- `lib/clone.rb`
- `lib/clone/`
- `lib/clone/version.rb`
- `lib/clone/gateway.rb`
- `lib/clone/services.rb`
- `lib/clone/entities.rb`
- `lib/clone/services/`
- `lib/clone/entities/`
- `lib/clone/services/service.rb`
- `lib/clone/entities/entity.rb`
- `test`
- `test/clone/`
- `test/clone/services/`
- `test/clone/entities/`

### Entity
{{id: fr.entity.template}}

### Service
{{id: fr.service.template}}

### Gateway

### Service Port
{{id: fr.port.template}}

## Functions

The system shall provide the following functions:

{{@@list}}

### Creating a new gem
{{id: fr.create.gem}}

The system shall provide the function for creating a new gem with provided name. The function shall just run the appropriate Bundler command `bundle gem NAME`.

When the directory named `NAME` already exist, the system must be cancelled and report the error `Canceled. Cannot clone to an existing folder`.

__Input parameters__

Parameter | Type   | M | Description
--------- | ------ | - | -----------
NAME      | String | 1 | the name for a new Cleon clone that should follow usual conventions for `bundle gem NAME` command

### Create structure
{{id: fr.create.structure}}

The system shall provide the function for creating [[fr.structure]] inside an existing gem.

When the gem with provided `NAME` was not found, the system shall report the error: `Gem 'NAME' not found`.

__Input parameters__

Parameter | Type   | M | Description
--------- | ------ | - | -----------
NAME      | String | 1 | the name for a new Cleon clone that should follow usual conventions for `bundle gem NAME` command __TODO__ it might be something in a snake_case or CamelCase; the system should try these both variants

__The command flow__ is following:

1. Check if a gem with `NAME` is exists already. Return `OK. The gem is already Cleon`, when the gem already exists and have all necessary concepts and structure.
2. Execute [[fr.create.gem]]
3. Create [[fr.structure]] inside the created gem.
4. Return `OK`

### Create service
{{id: fr.create.service}}

The system shall provide the function to create a new service. When the user requests the command, the system shall do the following flow:

- create a new service by using [[fr.service.template]] template with provided parameters;
- require the created service through `services.rb`;
- create the <service>_spec.rb file under `test/gem/services/`.

The function must check if it called inside the root folder of a Cleon's gem. When it was called elsewhere beside the gem root folder, the system must cancel the function and report the error `Cancelled. Cannot create a service for unknown gem`

It can check existence of `*.gemspec` file in working directory first, and then check presence of `lib/{base}/services` and `lib/{base}/entities` folders inside the working directory.

__Input parameters__

Parameter | Type   | M | Description
--------- | ------ | - | -----------
NAME      | String | 1 | the name for a new service
PARA      | String | 0..* | the service parameter; might be free (`cleon service name value`) or typed (`cleon service name:string value`) parameter.

__Examples__

* service(name)
* service(name, para1, para2)

#### NAME parameter and service names

The NAME parameter translated into service in the following way:

- the service name is getting by translating snake_case name into CamelCase;
- the service source file name is getting by translating CamelCase into snake_case;
- the test source file name is getting by adding `_spec` suffix to the service source file name.

Therefore, when the NAME parameters equals `some_service`, the service class shall be named as `class SomeService` and placed into `lib/clone/services/some_service.rb`; the test source shall be placed it `test/clone/services/some_service.rb`

#### Typed parameters

When a typed parameter PARA provided, the system shall

- create the argument guard for provided type;
- use the created guard in `initialize` method.

Argument guard is a class that just checks argument value. And there under "guarded arguments" means creating the guard class and check the argument inside the service `initialize`.

For an free argument the system just uses the argument as it is

```ruby
class SomeService < Service
  def initialize(param)
    @param = param
  end
end
```

For an guarded argument the system adds guard an check the argument value; so that for `cleon service some_service param:string` will be generated the following code

```ruby

# uncomment and provide a Proc for arguments guarding
# GuardString = ArGuard.new('string', 'must be String', Proc.new {|v| v.is_a? String})

class SomeService < Service
  def initialize(param)
    @param = GuardString.(param)
  end
end
```

### Create entity
{{id: fr.create.entity}}

Requirements are the same as for [[fr.create.service]]. Just [[fr.entity.template]] template must be used, and the entity source and test files must be placed in accordance with [[fr.structure]].

### Create ports
{{id: fr.create.ports}}

The system shall provide the function that generates set of service ports classes for the provides Cleon's gem.

__Input parameters__

Parameter | Type   | M | Description
--------- | ------ | - | -----------
SOURCE    | String | 1 | the name for gem with services that shall be ported inside the current gem
PORT_TO   | String | ? | the folder for placing crated ports, `lib/clone/ports` by default

__Use Case__

Actors and its interests:

- the user working on HTTP/JSON API inside `auth_api` gem wants to port the domain services placed inside `auth` gem.

__Success Scenario__

1. The user requests the system to `create ports` with provided parameter `SOURCE` and optionally `PORT_TO`.
2. The system checks that there is no `lib/clone/{PORT_TO}` inside `auth_api` gem, or in other word there are no services ports were created earlier.
3. The system gets all the services inside `SOURCE` gem (those can be found through requiring `auth` gem and getting constants inside the `Auth::Services` module.)
4. The system creates `lib/clone/{PORT_TO}` and `/test/clone/{PORT_TO}` folders, creates `/lib/clone/{PORT_TO}.rb` require file.
5. For each service got at the step 3, the system:
   - creates service port source file under `lib/clone/{PORT_TO}`;
   - creates service port test source file under `test/clone/{PORT_TO}`;
   - require created port source file in `/lib/clone/{PORT_TO}.rb`.
6. The scenario is finished.

__Scenario extensions__

__2a__. Service ports at `PORT_TO` are exist already: The system finishes the scenario with the error `Operation canceled because some ported services are exist`.

__3a__. The `SOURCE` gem was not found or does not have services: The system finishes the scenario with appropriate error.

# Interface requirements

The system shall provide the following interfaces:

{{@@list}}

## CLI

The CLI shall provide the following commands:

{{@@list}}

### 'cleon' command

The CLI interface shall provide the `cleon` command.

#### With no parameters

When the user requests `cleon` command with no parameters provided, the system shall print a banner for the user; the banner shall provide the system version information and explain the basic usage of the system.

#### With NAME parameter

When the user requests `cleon` command and provides `NAME` parameter, the system shall execute the [[fr.create.structure]] function with provided `NAME` parameter.

### 'cleon service' command

The CLI interface shall provide `cleon service` command. When the user requests the command, the system shall create a new service by using [[fr.create.service]] function.

When no parameters provided for the command, the system shall provide the user with the banner.

Examples:

    $ cleon service NAME [PARA1] [PARA2]
    $ cleon service store_named_value name value
    $ cleon service store_named_value name:string value

### 'cleon entity' command

The CLI interface shall provide `cleon entity` command. When the user requests the command, the system shall create a new service by using [[fr.create.entity]] function.

When no parameters provided for the command, the system shall provide the user with the banner.

Examples:

    $ cleon entity NAME [PARA1] [PARA2]
    $ cleon entity credentials email secret
    $ cleon entity credentials email:email secret:secret

### 'cleon port' command

The CLI interface shall provide `cleon port` command. When the user requests the command, the system shall create a new service by using [[fr.create.ports]] function.

When no parameters provided for the command, the system shall provide the user with the banner.

Examples:

    $ cleon port SOURCE [PLACE_TO]
    $ cleon port auth
    $ cleon port auth 'lib/auth_api/ports'
