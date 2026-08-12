# Ultimate Dodger (Godot 4)

A minimal Godot 4 project reproducing the simple mobile game: a horizontally-bouncing player and a single on-screen button that toggles a slow/fast speed multiplier.

How to run
1. Install Godot 4.x.
2. Open this folder as a project in Godot Editor.
3. Open scenes/Main.tscn and press Play Scene (F6). To make this the default Run scene: Project -> Project Settings -> Run -> Main Scene -> set to res://scenes/Main.tscn and save.

Notes
- The Player node procedurally generates a circular placeholder sprite if no texture is set.
- The button is placed in a CanvasLayer so it remains screen-fixed and large enough for mobile.

Files added
- project.godot
- scenes/Main.tscn
- scripts/player.gd
- scripts/main.gd
- .gitignore

If you want, I can:
- Add sound or particles
- Add Android export preset
- Tweak controls or UI layout for different aspect ratios
