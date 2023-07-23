# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## unreleased

put your changes here

## [0.1.0] - 2023-07-24

### Changed

* the `EctoNamedFragment` module needs to be imported now (no more `use`)
* changed interpolation syntax to use string interpolation (#{}). Please change your query strings from `named_fragment("foo(:a, :b)", a:1, b:2)` to `named_fragment("foo(#{:a}, #{:b})", a:1, b:2)`
  * this allows better syntax highlighting of param names within the query
  * it also drastically simplifies implementation of this library and improves compile times of this library as well as of the named_fragment macro


## [0.1.0] - 2023-07-17

### Added

* initial release
