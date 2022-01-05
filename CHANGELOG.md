## [Unreleased]

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
