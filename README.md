# Tower Defense (working title)

Scaffold for a 3D isometric tower defense game in Godot 4.5. The repo is organized for scalability, clean diffs, and multi-OS builds.

## Project layout
- `addons/` Godot plugins (optional)
- `assets/` Art, audio, VFX, shaders
- `scenes/` Game and entity scenes
- `scripts/` Gameplay code (GDScript/C#)
- `resources/` Data files (waves, grids, materials, configs)
- `ui/` UI scenes, themes, icons
- `tests/` Sandboxes and debug tools
- `builds/` Export outputs (gitignored)
- `docs/` Design and architecture docs

## Cross-platform prep (Windows / macOS / Linux)
- Line endings: `.gitattributes` forces LF for Godot/text files and marks binaries; avoids CRLF/LF churn across OSes.
- Paths and casing: keep filenames lower_snake or kebab; avoid case-only differences and use forward slashes in code/resources.
- Input: define actions in Project Settings > Input Map; avoid hardcoded keycodes so remapping works everywhere.
- Assets: stick to portable formats (PNG, OGG, WAV); avoid non-ASCII filenames. Shaders should avoid platform-specific extensions.
- Export presets: add exports for Windows, macOS, Linux once the project file exists. macOS builds need signing/notarization to avoid Gatekeeper warnings; Windows benefits from code signing to reduce SmartScreen prompts; Linux often ships as AppImage or a self-contained folder.
- CI later: plan a GitHub Actions workflow to lint/test and produce exports per platform once presets are defined.

## Getting started
1) Open the folder in Godot 4.5 and create the project (choose a final name later).
2) Add export presets for Windows/macOS/Linux and set the output paths under `builds/`.
3) Wire up the Input Map and create initial scenes/scripts under `scenes/` and `scripts/`.
4) Keep docs under `docs/` (e.g., architecture/design notes).

## License / rights
All rights reserved. No redistribution, copying, or reuse without explicit written permission. The repository is public for visibility, but no license is granted until explicitly added.
