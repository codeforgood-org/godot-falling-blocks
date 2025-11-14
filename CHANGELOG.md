# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete project reorganization with proper Godot 4 structure
- Modular scene-based architecture
- Start menu with game instructions
- Comprehensive HUD showing score, time, and difficulty level
- Game over screen with statistics
- Pause functionality
- Progressive difficulty system
- High score persistence
- Score system (points for dodging blocks)
- Restart functionality (press R)
- Collision particle effects
- Custom UI theme
- Comprehensive documentation (README, CONTRIBUTING)
- Development tooling (.editorconfig, export presets)
- Proper directory structure for assets and scenes

### Changed
- Split monolithic script into separate, focused modules
- Improved code organization and documentation
- Enhanced player controls (added A/D keys)
- Better game flow with proper state management

### Fixed
- Proper collision detection
- Memory management with queue_free()
- Viewport boundary constraints

## [0.1.0] - 2025-05-10

### Added
- Initial prototype with basic gameplay
- Player movement (left/right)
- Falling blocks
- Simple collision detection
- Basic game over state

[Unreleased]: https://github.com/codeforgood-org/godot-falling-blocks/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/codeforgood-org/godot-falling-blocks/releases/tag/v0.1.0
