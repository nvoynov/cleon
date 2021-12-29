## [Unreleased]

## [0.3.0] - 2021-12-27

- Added `Cleon::Services::CloneThing` service for generating services and entities. The service generates source `.rb` file and requires the source inside `entities.rb` or `services.rb` respectively; it also creates `_spec.rb`.
- Added helpers `Cleon.copy_thor`,`Cleon.clone_cleon`, `Cleon.clone_entity`, `Cleon.clone_service`.
- Added `exe/cleon` for cloning cleon, and cloning separate services and entities

Templates for all those generators mentioned can be found in `lib/erb` directory. It also relies on the following gem structure:

- lib
- lib/{base}
- lib/{base}/entities
- lib/{base}/services
- test
- test/{base}
- test/{base}/services
- test/{base}/entities

## [0.2.0] - 2021-12-27

- The `ArgChkr` class replaced by `ArGuard` in accord to Dogen
- Improved tests. Now pathed gem checks by ruby -e

## [0.1.1] - 2021-12-20

- Refactored CloneCleonCode

## [0.1.0] - 2021-12-06

- Initial release
