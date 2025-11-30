# Tower Defense Game Design Overview

This document summarizes the **current design decisions** and **core concepts** established for the 3D isometric tower defense game.

---

#  High-Level Vision
A **3D isometric tower defense game** built in **Godot 4**, targeting a **high-fidelity stylized visual style** with a development approach that starts with **graybox assets** and transitions into polished art later.

The emphasis is on:
- Strong visual identity (stylized high-fidelity models)
- Tight and readable gameplay
- Modular systems for towers, enemies, levels, and wave design
- Strong separation of data, visuals, and logic
- Scalability for future content or co-op/multiplayer (optional later)

---

#  Core Technology Stack
- **Game Engine:** Godot 4 (3D)
- **Language:** GDScript (or potential C# for certain systems)
- **Version Control:** Git + GitHub
- **Editor:** VS Code
- **Assets:** Placeholder/graybox first  polished PBR/stylized art later
- **Platform Targets:** Steam + GOG (DRM-free)

---

#  Visual Style
- Final target: **High-fidelity stylized 3D**, similar to modern polished indie visuals.
- Early development: **Graybox meshes + simple materials**, swappable later.
- Consistent material slots and scale to support easy art upgrades.

---

#  Camera & Perspective
- **3D isometric camera** (angled top-down)
- Smooth panning/zooming
- Optional edge scrolling / drag scrolling
- Orthographic or perspective (to be chosen later)

---

#  Level Structure
The game uses a **grid-based logical level** stored in data, rendered as a 3D world.

### Level components:
- **Grid data structure** (logical, not visible)
- **Path waypoints** for enemies
- **Buildable tiles** or tower pads
- **Spawn point(s)** for waves
- **Goal node** where enemies escape
- **3D environment mesh** built around the grid

This makes it easy to:
- Swap environment art later
- Maintain consistent gameplay across levels
- Scale up content over time

---

#  Enemy System
### Enemy Scene
- Uses a 3D node (CharacterBody3D)
- Follows the path via waypoint navigation
- Supports health, armor, movement speed, resistances
- Supports status effects (slow, burn, shock, etc.)
- Alerts managers when:
  - It dies
  - It reaches the goal
  - It applies score or damage to player

### Enemy Types (initial ideas)
- Basic
- Fast
- Tanky
- Swarm
- Shielded / armored
- Boss-type

---

#  Tower System
### Tower Scene
- Each tower is a Node3D with a mesh, range collider, and targeting logic
- Towers acquire targets via **EnemyManager**
- Fire **projectiles** or apply instant effects
- Each tower:
  - Has upgrade tiers
  - Uses standardized footprint (grid-aligned)
  - Emits VFX when attacking

### Potential Tower Types
- Basic turret
- Sniper
- Splash/AOE
- Magic DOT tower (burn, poison)
- Slow/freeze tower
- Utility tower (buffs nearby towers)

---

#  Projectile System
**Projectiles are standalone scenes** that:
- Move toward a target or location
- Check for collision/hit
- Apply damage/effects
- Trigger impact VFX
- Despawn automatically

Types may include:
- Bullets
- Rockets
- Arcing projectiles (balls, grenades)
- Lasers / beams
- Magical homing shots

---

#  Wave System
### WaveManager
- Loads wave definitions (from JSON or .tres)
- Spawns enemies in sequence
- Supports:
  - Time-based waves
  - Mixed enemy types
  - Boss waves
  - Reward distribution
  - Multiple difficulty modes

### Wave Data Format
Each wave can define:
- Enemy type
- Count
- Spawn interval
- Spawn lane/path
- Special modifiers (e.g., faster, armored)

---

#  Managers Overview
Managers coordinate high-level systems:

- **GameRoot**  main orchestrator
- **Level**  loads and visualizes the map
- **TowerManager**  building, selling, upgrading
- **EnemyManager**  tracking enemies + providing targeting lists
- **WaveManager**  spawning waves
- **ProjectileManager (optional)**  pooling & performance
- **UI/HUD**  player interface

---

#  Core Scene Architecture (Summary)
```
GameRoot
  Level
  WaveManager
  EnemyManager
  TowerManager
  CameraRig
  HUD
  Audio
```

Enemies:
```
Enemy
  Mesh
  Collision
  HealthBar
  Script (Enemy.gd)
```

Towers:
```
Tower
  Mesh
  RangeArea
  FirePoint
  Script (Tower.gd)
```

---

#  Current Design Status
 Engine chosen  
 Camera style chosen  
 Visual pipeline approach chosen  
 Grid + waypoint system chosen  
 Flowchart architecture complete  
 Folder structure drafted  
 Core scenes defined  
 Enemy, Tower, Projectile, Wave systems outlined

Next steps may include:
- Building the **actual Godot scene skeletons**
- Creating a **Level grid resource format**
- Creating **basic graybox prototype** for towers + enemies
- Planning the **upgrade system** in more detail
- Drafting a **gameplay loop / economy system** (gold, lives, rewards)

---

If you want, we can now expand this into:
- A full **Game Design Document (GDD)**
- A **mechanics deep dive** (economy, damage types, synergy)
- A **visual bible**
- A **task roadmap** for development


