# Ultimate Dodger (Godot 4)

A minimal Godot 4 project reproducing the simple mobile game: a horizontally-bouncing player and a single on-screen button that toggles a slow/fast speed multiplier.

This repository is configured for PORTRAIT orientation by default (720x1280 window size and 2D stretch).

How to run
1. Install Godot 4.x.
2. Open this folder as a project in Godot Editor.
3. Open scenes/Main.tscn and press Play Scene (F6). To make this the default Run scene: Project -> Project Settings -> Run -> Main Scene -> set to res://scenes/Main.tscn and save.

Notes
- The Player node procedurally generates a circular placeholder sprite if no texture is set.
- The button is placed in a CanvasLayer so it remains screen-fixed and large enough for mobile.
- To change the portrait target size, edit project.godot under [display/window] (size/width and size/height) or adjust Project Settings -> Display -> Window.

Files added
- project.godot (main_scene set to res://scenes/Main.tscn, window size set to portrait)
- scenes/Main.tscn
- scripts/player.gd
- scripts/main.gd
- .gitignore

If you want, I can:
- Add Android export preset and orientation-specific export settings.
- Resize/copy UI anchors for multiple aspect ratios or add safe-area handling.
