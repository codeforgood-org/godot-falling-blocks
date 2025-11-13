# Assets Directory

This directory contains all game assets organized by type.

## Directory Structure

```
assets/
├── fonts/          # Font files (.ttf, .otf)
├── sounds/         # Audio files
│   ├── music/     # Background music
│   └── sfx/       # Sound effects
├── sprites/        # Images and sprite sheets
│   ├── blocks/    # Block sprites
│   ├── player/    # Player sprites
│   └── ui/        # UI elements
└── themes/         # Godot UI themes
```

## Asset Guidelines

### Sprites
- **Format:** PNG with transparency
- **Naming:** Use descriptive snake_case names (e.g., `player_idle.png`)
- **Organization:** Group related sprites in subdirectories

### Sounds
- **Format:** OGG Vorbis (preferred) or WAV
- **Naming:** Descriptive names indicating the sound (e.g., `block_collision.ogg`)
- **Quality:** 44.1kHz, 16-bit minimum

### Fonts
- **Format:** TTF or OTF
- **License:** Must be open license compatible with MIT
- **Include:** License file with font attribution

### Themes
- **Format:** Godot .tres resource files
- **Naming:** Descriptive purpose (e.g., `main_theme.tres`)

## Adding New Assets

1. Place asset in appropriate subdirectory
2. Update this README if adding new categories
3. Ensure proper licensing and attribution
4. Test in-game before committing

## Current Assets

### Themes
- `main_theme.tres` - Default UI theme

## Placeholder Assets

Currently, the game uses Godot's built-in ColorRect nodes for simplicity. You can replace these with custom sprites:

- **Player:** Blue ColorRect (50x50) → Add sprite to `sprites/player/`
- **Blocks:** Red ColorRect (40x40) → Add sprite to `sprites/blocks/`
- **Background:** Solid color → Add background image to `sprites/`

## Contributing Assets

See [CONTRIBUTING.md](../CONTRIBUTING.md) for asset contribution guidelines.

All assets must be:
- Original work or properly licensed
- Compatible with the MIT license
- Appropriately attributed if required
- High quality and matching the game's style
