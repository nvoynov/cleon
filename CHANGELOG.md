## [Unreleased]

TODO

- Change cloned gem structure by moving all the basics (ArGuard, Entity, Service) into `basics` folder
- Added new `cleon ports CLEON PLACE_TO` command. It checks if it called inside just some gem; then gets all services from Cleon's clone `CLEON` and creates and require ports for those.

## [0.5.0] - 2022-01-09

- Removed `cleon clone` and replaced by `cleon CLONE`. Now it creates a new Cleon's gem named `CLONE` and populate it by Cleon's folders and files. Before cloning it ensures that there is no `CLONE` directory exist in the working directory. Your `CLONE` cannot be `arguard`, `service`, `entity`, or `port`.
- Added new `cleon guard NAME` command that checks if it called inside Cleon's gem and creates a new guard inside `{base}::ArGuards`.
- Improved `cleon service` and `cleon entity`. Now these checks if it called inside Cleon's gem, creates a new thing and require it. Its also accepts typed parameters `param:type` and guards such typed arguments in initialize.

## [0.4.1] - 2021-12-31

- Only one Cleon::Gateway left. Therefore no 'gateways' folder, Cleon require only 'gateway'

## [0.4.0] - 2021-12-31

- Added CLI interface
- Added generators for creating new services and entities

Templates of all generators can be found in `lib/erb` directory. Generaton process relies on the following gem structure, where {base} is a root gem folder:

- lib
- lib/{base}
- lib/{base}/entities
- lib/{base}/services
- test
- test/{base}
- test/{base}/services
- test/{base}/entities

## [0.3.0] - 2021-12-27

- Added generators and CLI, but it was too clumsy

## [0.2.0] - 2021-12-27

- The `ArgChkr` class replaced by `ArGuard` in accord to Dogen

## [0.1.0] - 2021-12-06

- Initial release
