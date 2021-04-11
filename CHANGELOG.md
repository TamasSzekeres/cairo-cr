# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.0] - 2021-04-??
- Updated to Crystal 1.0.0
### Added
- Documentation
- Pdf types:
  - `PdfOutlineFlags`
  - `PdfMetadata`
- Pdf functions:
  - `PdfSurface#set_metadata`
  - `PdfSurface#set_page_label`
  - `PdfSurface#set_thumbnail_size`

## [0.3.1] - 2020-09-23
- Updated to Crystal 0.35.1

## [0.3.0] - 2019-10-13
- Updated to Crystal 0.31.1
### Fixed
 - Must rename `unsafe_at` to `unsafe_fetch` in `Cairo::RectangleList` (#8, thanks @DmitryBochkarev)

## [0.2.2] - 2018-06-17
### Fixed
- namespace missing in `Context::initializer` (#7, thanks @hodefoting)

## [0.2.1] - 2018-03-21
### Fixed
- `Context::font_face` function (#6, thanks @bird1079s)

## [0.2.0] - 2018-01-20
### Added
- High level classes and structs.
### Changed
- **(breaking change)** Low level binding moved to **C** namespace
- **(breaking change)** `Cairo` binding class renamed to `LibCairo`

## [0.1.0] - 2017-05-18
- First release
