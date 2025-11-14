# Contributing to Falling Blocks

First off, thank you for considering contributing to Falling Blocks! It's people like you that make this game better for everyone.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project and everyone participating in it is governed by basic principles of respect and collaboration:

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Assume good intentions
- Keep discussions professional and on-topic

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Screenshots** if applicable
- **System information** (OS, Godot version)
- **Additional context** that might be helpful

### Suggesting Features

Feature suggestions are welcome! Please provide:

- **Clear use case** - Why is this feature needed?
- **Proposed solution** - How should it work?
- **Alternatives considered** - What other approaches did you think about?
- **Additional context** - Mockups, examples, etc.

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** following our coding standards
4. **Test thoroughly** in Godot editor
5. **Commit your changes** with clear messages
6. **Push to your branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

## Development Setup

### Prerequisites

- [Godot Engine 4.3+](https://godotengine.org/download)
- Git
- A code editor (VS Code with godot-tools extension recommended)

### Getting Started

1. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/godot-falling-blocks.git
   cd godot-falling-blocks
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/codeforgood-org/godot-falling-blocks.git
   ```

3. **Open in Godot**
   - Launch Godot Engine
   - Import the project
   - Run and test

### Project Structure

Familiarize yourself with the project structure:

```
scenes/         # Scene files (.tscn)
scripts/        # GDScript files (.gd)
assets/         # Game assets (sprites, sounds, fonts)
```

## Coding Standards

### GDScript Style Guide

Follow the [official Godot GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

#### Key Points

**Naming Conventions:**
```gdscript
# Classes: PascalCase
class_name PlayerController

# Functions and variables: snake_case
func calculate_damage():
    var total_damage = base_damage + bonus_damage

# Constants: UPPER_SNAKE_CASE
const MAX_HEALTH = 100

# Signals: past tense
signal door_opened
signal item_collected
```

**Type Hints:**
```gdscript
# Use type hints for clarity
func move_player(direction: Vector2, speed: float) -> void:
    var new_position: Vector2 = position + direction * speed
    position = new_position
```

**Documentation:**
```gdscript
## Brief description of the class
##
## Detailed explanation of what this class does,
## its responsibilities, and how to use it.
class_name MyClass

func my_function(param: int) -> bool:
    """Short description of the function

    Detailed explanation if needed.
    """
    return true
```

**Code Organization:**
```gdscript
# 1. Class definition
extends Node2D
class_name GameManager

# 2. Signals
signal game_started
signal game_ended

# 3. Constants
const MAX_PLAYERS = 4

# 4. Exported variables
@export var player_speed: float = 300.0

# 5. Public variables
var current_score: int = 0

# 6. Private variables
var _internal_state: bool = false

# 7. Onready variables
@onready var sprite = $Sprite2D

# 8. Built-in virtual methods
func _ready():
    pass

func _process(delta):
    pass

# 9. Public methods
func start_game() -> void:
    pass

# 10. Private methods
func _update_internal_state() -> void:
    pass
```

### Best Practices

1. **Keep functions small** - Aim for functions under 20 lines
2. **Single responsibility** - Each function should do one thing well
3. **Use meaningful names** - Code should be self-documenting
4. **Avoid magic numbers** - Use named constants
5. **Comment complex logic** - Explain the "why", not the "what"
6. **Handle errors gracefully** - Check for null, validate inputs
7. **Performance matters** - Avoid unnecessary computation in `_process()`

### Scene Organization

- Keep scenes focused and modular
- Use scene inheritance when appropriate
- Separate logic (scripts) from presentation (scenes)
- Use groups for easy node access
- Organize nodes in a logical hierarchy

## Commit Guidelines

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat: add pause functionality

Implemented pause menu with ESC key binding.
Game now properly pauses all physics and animations.

Closes #42
```

```
fix: resolve collision detection edge case

Fixed bug where player could collide with blocks
that were just spawned off-screen.

Fixes #56
```

### Commit Best Practices

- **One logical change per commit**
- **Write clear, descriptive messages**
- **Present tense** ("add feature" not "added feature")
- **Reference issues** when applicable
- **Keep commits atomic** - each commit should work

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New features are documented
- [ ] No unnecessary files committed
- [ ] Commit messages are clear

### PR Template

When opening a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
How was this tested?

## Screenshots (if applicable)
Add screenshots or GIFs

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex areas
- [ ] Updated documentation
- [ ] No breaking changes (or documented)
```

### Review Process

1. **Automated checks** run first
2. **Maintainer review** - may request changes
3. **Address feedback** - make requested changes
4. **Approval and merge** - once approved, will be merged

### After Your PR is Merged

- Your changes will appear in the next release
- You'll be added to the contributors list
- Thank you for contributing!

## Asset Contributions

### Sprites and Graphics

- **Format:** PNG with transparency
- **Size:** Power-of-two dimensions preferred (32x32, 64x64, etc.)
- **Style:** Match existing art style
- **License:** Must be compatible with MIT

### Sounds and Music

- **Format:** OGG Vorbis preferred, WAV acceptable
- **Quality:** 44.1kHz, 16-bit minimum
- **Length:** Keep file sizes reasonable
- **License:** Must be compatible with MIT

### Fonts

- Must have open license (OFL, CC0, etc.)
- Include license file with attribution

## Questions?

- **Not sure where to start?** Check issues labeled `good first issue`
- **Need help?** Open a discussion or comment on an issue
- **Found something unclear?** Documentation PRs are welcome!

## Recognition

Contributors will be recognized in:
- README.md contributors section
- CHANGELOG.md for each release
- GitHub's contributor graph

Thank you for making Falling Blocks better! 🎮✨
