% Cleon User Stories

# Clean code structure
{{id: us.struct}}

As a dev, I want to hold my code "clean" and "user-oriented", so it will be easy to write, read, and evolve in the future.

To achieve this I'm going to design my code according to The Clean Architecture principles. At the core level, I'm going to have just three concepts - services (algorithms, use cases, interactors), entities (data structures), and abstract gateway. Going further, I want the ability to create ports for all the domain services

# Create "clean" skeleton
{{id: us.create.skeleton}}

As a dev, when I start a new project, I want to create the "clean" skeleton of the project packed in Ruby gem, so that I'll get the code of the core concepts of services and entities necessary to evolve the project ideas from.

## Create a new "clean"
{{id: us.create.gem}}

When I do not have the gem for the project, I want to create a new gem for it.

## Copy "clean" structure
{{id: us.clone.skeleton}}

__UNDER CONSTRUCTION__ just cloning Cleon into an existing gem seemed a perfect idea at the beginning, but the more I'm brooding in terms of "generators" the more I reckon that straight and natural behavior will be just creating a new gem and populating it by Cleon's structure and concepts.

When I have the gem for the project already, I want just to copy or clone the "clean" structure and core concepts to the existing gem.

# Basic toolbox

## Create and require
{{id: us.create.concept}}

As a dev, when I work on a certain project, I want to have some basic tools which will help me with tasks that are quite boring, like creating and requiring source files for services and entities, so it'll eliminate distraction on right code structuring.

I want to have basic tools to create source code files and test code file for argument guards, entities, and services. It might be just CLI

    $ cleon arguard NAME
    $ cleon service NAME [PARA1] [PARA2]
    $ cleon entity  NAME [PARA1] [PARA2]

## Recreate safely
{{id: us.recreate.safely}}

When I'm creating a concept a second or more time and its source and test files already exist, I want the system to check if previously generated files were changed manually. When such a file was not changed, the system should replace the existing one with newly generated. When any manual changes were made, the system should back up the existing file before placing a new one.

## Port services
{{id: us.port.services}}

When I have stable calling interfaces of my domain services, I want to port those services for different domain faces like HTTP or client over HTTP, so that it will help me with creating such scopes based on ready for using domain services.

> __Why one would need service ports?__ Suppose, one has created some clean domain in Cleon's way and wants to provide some specific interface to the domain, eg. HTTP JSON API. The domain services accept ruby arguments and produce a ruby response. The HTTP JSON API accepts HTTP requests and responds by HTTP responses.
> Having that __problem of translating HTTP requests to Ruby__ to call the service and translating Ruby to HTTP response, one could create ports for all the domain services to do those boring manipulations.
> __In the case of API client libraries__, the task might be the opposite - porting pure ruby parameters into the HTTP request, and in this case, the interface of an client library method will resemble the interface of a calling service.
> __Upon superficial examination__ of this idea, it turned out that the code of the service ports will depend quite strongly on the specific implementation of the target interface. Therefore, here it is worth considering only specific face implementation, eg. the domain HTTP layer or the domain client library over HTTP.

## Port from other sources
{{id: us.port.services.from}}

When I develop the domain and its interface in a separate gem, I want to have the ability to port the domain services from the domain's gem to the interface's gem, that way I can easily port different domain services into a separate client library or API.

## Clean source tree '*.rb~'

When I extensively create and require source files by using [[us.create.concept]] and [[us.recreate.safely]] features and consequently have some `*.rb~` backups, I want to have the ability to clean my source code from those files.

# Advanced toolbox

## Generate domain skeleton

When I have all basic tools like argument guards, services, and entities generators, it seems quite tempting to get the ability to describe the whole domain in these concepts and then generate the whole domain by that description.

It might be some kind of command-line scenario, or maybe full-fledged DSL

```bash
# -= Some Domain =-
# -= Some Domain. Argument Guards =-
guard uid
guard string
guard secret
guard email
guard integer
guard money
guard more_than_5_integer
# -= Some Domain. Entities =-
entity user uid:uid name:string email:email
entity credentials email:email secret:secret
# -= Some Domain. Services =-
service authenticate email:email secret:secret
service register_user name:string email:email secret:secret
service change_secret email:email old_secret:secret new_secret:secret
```

## Get skeleton statistics

When I have quite a bunch of source files generated, I want to get some statistics of those files, maybe also have some history.

Concepts | Total | Untouched | Estimation
-------- | ----- | --------- | ----------
entities | 27    | 9         | 9 * 3 hour
services | 24    | 2         | 2 * 3 hour
