# Project Folder Structure (Tower Defense Game)

This document outlines the recommended folder structure for the 3D isometric tower defense game built in **Godot 4**, using **Git/GitHub**, and targeting **highfidelity stylized visuals** (with graybox assets early on).

---

##  Root Structure
```
 project_root/

 addons/                # Godot plugins (optional)
 assets/                # Art, audio, shaders, VFX
 docs/                  # Design docs, diagrams, markdown
 scenes/                # All Godot scenes
 scripts/               # All GDScript/C# code
 resources/             # Data: grids, waves, JSON, materials
 ui/                    # UI scenes + styles
 builds/                # Exported builds (gitignored)
 tests/                 # Automated or manual QA setups
 README.md
```

---

##  assets/
```
assets/
 models/                # 3D models (placeholder + final)
 textures/              # Textures, atlases, masks
 materials/             # Shader materials & PBR sets
 audio/
    sfx/
    music/
 vfx/                   # Particle textures, flipbooks
```

---

##  scenes/
```
scenes/
 core/                  # Primary gameplay scenes
    GameRoot.tscn
    Level.tscn
    CameraRig.tscn
    WaveManager.tscn
    EnemyManager.tscn
    TowerManager.tscn
    ProjectileManager.tscn (optional)

 enemies/               # All creep types
    Enemy_Basic.tscn
    Enemy_Fast.tscn
    Enemy_Tank.tscn

 towers/                # All tower types
    Tower_Basic.tscn
    Tower_Sniper.tscn
    Tower_AOE.tscn

 projectiles/           # Bullets, missiles, lasers
    Projectile_Bullet.tscn
    Projectile_Missile.tscn
    Projectile_Laser.tscn

 environment/           # Decorations, props, tiles
     trees/
     rocks/
     cliffs/
```

---

##  scripts/
```
scripts/
 core/
    GameRoot.gd
    Level.gd
    WaveManager.gd
    EnemyManager.gd
    TowerManager.gd
    CameraRig.gd
    Grid.gd               # Grid data structure

 towers/
    Tower.gd              # Base class
    Tower_*Type*.gd       # Variants

 enemies/
    Enemy.gd              # Base class
    Enemy_*Type*.gd       # Variants

 projectiles/
    Projectile.gd         # Base class
    Projectile_*Type*.gd

 ui/
     HUD.gd
     BuildMenu.gd
     TowerUpgradeUI.gd
```

---

##  resources/
```
resources/
 waves/                    # Wave definitions (JSON / .tres)
    wave_01.tres
    wave_02.tres

 grids/                    # Level grid + tile data
    level1_grid.json
    level2_grid.json

 materials/                # Reusable materials
 data/                     # Any misc configs
```

---

##  ui/
```
ui/
 scenes/                   # HUD, menus, overlays
    HUD.tscn
    BuildMenu.tscn
    UpgradePanel.tscn

 themes/                   # Godot theme files
 icons/                    # Buttons, indicators
```

---

##  docs/
```
docs/
 architecture/            # Flowcharts, diagrams
 design/                  # Game design docs
 lore/                    # Optional narrative docs
 notes/                   # Brainstorming & misc
```

---

##  tests/
```
tests/
 sandbox/                 # Quick test maps/scenes
 debug_tools/             # Helpers, performance tests
```

---

##  builds/ (gitignored)
```
builds/
 windows/
 linux/
 playtest_builds/
```

---

##  Notes
- This structure keeps **logic, scenes, assets, and configs separated**, which is ideal for scaling.
- It also supports easy future upgrades (art pass, VFX pass, additional levels).
- Clean structure  easier Steam/GOG packaging and cleaner Git diffs.

---

Let me know if you'd like me to add a **README.md**, diagrams, or expand any folder's purpose.


