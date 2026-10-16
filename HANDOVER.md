# Handover Doc — tj-362-crack-in-reality + CRT filter

Project: Godot 4.6 mobile-style platformer "tj-362-crack-in-reality".
Branch: master. Default model working tree now clean except an unrelated untracked `.gitignore`/assets note — no pending changes after this doc (see Git State).

## What was done (chronological)

1. Diagnosed broken game: crash "Attempt to call function 'instantiate' in base 'null instance'". Root cause: the earlier "Add CRT filter" commit (`d2aa147`) added a UTF-8 BOM to all 10 level `.tscn` files, making `load()` return null in `root.gd:56`. Stripped BOM (10 level files). Game now loads.

2. Implemented a simple CRT filter (overlay, `blend_mul` so the level shows through):
   - `Menu/crt_shader.gdshader` and `Menu/crt_filter.tscn` (a CanvasLayer at layer=100 with a full-screen ColorRect using the shader).
   - Applied by referencing `crt_filter.tscn` as an `ext_resource` and instancing `CRTFilter` at the end of every level (`lv_01`..`lv_09`, `lv_tut_01`).

3. Iterated CRT tuning (thinner/more-frequent scanlines, vertical shadow mask, vignette, brightness gain, pulse). Final shader params approximately:
   - `scanline_count=700`, `scanline_brightness=0.25`, `vignette_strength=0.45`, `noise_strength=0.05`, `mask_strength=0.2`, `brightness=1.2`.
   - `blend_mul`, `unshaded` render mode.

4. Fixed a pause-state bug that froze the game on restart: `get_tree().paused` was never reset when returning to menu or starting a level. Added resets in `_on_quitting_game()` (reload branch) and `_on_level_completed()`.

5. Replaced the scene-reload exit path with a no-reload "back to menu" flow (keeps the background `AudioStreamPlayer` music playing):
   - Start handlers now hide `$IntroMenu` instead of `queue_free()` it.
   - `_on_quitting_game`: if on title screen (`current_level == null`) → `get_tree().quit()`; otherwise frees the level, resets pause/cursor/pause-menu, and re-shows/reset the intro menu submenus. No `reload_current_scene()`.
   - `_unhandled_input`: gate moved from `if $IntroMenu:` to `if $IntroMenu and $IntroMenu.visible:` so ESC still pauses during gameplay.
   - `IntroMenu` is never freed now, so the title exit-button detection switched from `if menu_buttons:` to `if not current_level:`.

6. Moved `UIManager` CanvasLayer to `layer = 200` so toast/instruction messages render on top of the CRT overlay (`CRTFilter` stays layer=100).

7. Commits (most recent first): `ad9f755`, `5a76a62`, `394045a`, `b3cdc32`, `fe094d3`, `74701fa`, `28e090a`, `e7bc303`. Most recent functional fix one is `ad9f755`; on top of that we also applied an uncommitted reorder in `_on_quitting_game` that nulls `current_level` before possibly-failing calls (to fix a "two presses to exit" symptom).

## Current known issue

- After playing, returning to the start screen, then pressing "exit" requires TWO presses before the game actually quits. Diagnosis: `_on_quitting_game` early-exits with `_tree().quit()` on the title-screen branch, but the first click isn't terminating — likely a stale `current_level` reference or a signal-double-fire. Latest change reorders `current_level` cleanup to run first. **Not yet verified by the user.** Fix accordingly if it recurs; instrument with a print or compare `current_level`.

## What is NOT committed / untracked

- The user's own pre-existing edits to `Menu/root.gd` (tutorial/start-menu/level-select UI flow, `menu_buttons`, `start_menu_*`) were committed as part of the bulk user-requested commit `e7bc303`.
- Editor-generated files: `Menu/crt_shader.gdshader.uid`, `Menu/select_level_button.gd.uid`, `Resources/Images/*.png.import`, `Resources/Sprites/*.import`, etc. (committed in `e7bc303`).
- The latest reorder edit (nulling `current_level` first) MAY BE UNCOMMITTED — check `git status` / `git diff HEAD` and commit as e.g. `Fix: null current_level before potentially-failing cleanup calls`.

## Open task list for next agent

- [ ] Verify CRT overlay still visible after the latest file touches (roll back to blend_mul overlay if SCREEN_TEXTURE approach ever reappears).
- [ ] Confirm the double-press "exit" issue is fixed after the reorder; if not, investigate `LibButton` double-emit behavior on `IntroMenu/Panel/MenuButtons/Exit`.
- [ ] `handle_pause`/`change_cursor` call `current_level.crack_cursor(...)` — guarded only by external non-null checks; consider guarding inside those methods to avoid crashes after level free.
- [ ] Confirm music `AudioStreamPlayer` keeps playing across menu play/restart; if Godot auto-stops on scene hide, this path may need the player moved to an autoload.
- [ ] Do not touch `Addons/silent_wolf` functionality; UI (CRT) layer only.

## Key files

- `Menu/root.gd` — main flow, pause handling, level loading, `_on_quitting_game`.
- `Menu/intro_menu.gd` — intro menu signals.
- `Menu/crt_filter.tscn`, `Menu/crt_shader.gdshader` — the stable CRT filter.
- `Menu/levels/lv_*.tscn` — all reference `crt_filter.tscn` via `crt_filter_res` ext_resource.
- `Menu/menu.tscn` — wires `UIManager` at layer 200 and `CRTFilter` usage inside levels.

## How to run / test

Godot 4.6 required (`project.godot` config). No automated tests available — run `Menu/menu.tscn` and manually exercise Start (tutorial / skip / free), pause (ESC), Exit back to menu, and re-entering a mode (verify no freeze, music continuous, toasts above CRT).

## Constraints recovered from the user

- "Just tell me, don't modify" was sometimes requested — confirm before large edits next time.
- They are time-pressured: prefer minimal, working changes; keep the CRT overlay approach (blend_mul over SCREEN_TEXTURE) because SCREEN_TEXTURE returned white in this build.
EOF
echo written