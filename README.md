# Waypoint for KDE Plasma 6 — 0.2.0

Graphite surfaces, steel detailing and machined-amber focus, in Dark and Light.
By DigitalCohesion.

## What you get
- **Global Themes** Waypoint Dark and Waypoint Light, with the Waypoint splash screen
- **Plasma Styles** (panels, popups, widgets) with flat task buttons
- **Colour schemes**, Dark and Light
- **Window decorations** (Aurorae): 8 px rounded top corners, a 2 px amber border on the focused
  window, an amber close button
- **Kvantum app style**: translucent windows and menus
- **Icons**: grey folder icons (everything else comes from Breeze), and the Waypoint logo as the
  panel's launcher icon and as an app icon (also installed in the standard hicolor theme)
- **Cursors**: Breeze cursors recoloured for Dark and Light
- **Wallpaper** "Crescent": mountains and lake, a crescent moon at dusk for Dark and a low sun for Light;
  sizes 1920×1080, 2560×1440, 3840×2160 and 3440×1440 (ultrawide)
- **Wallpaper** "Outpost": a mountain outpost, at dusk for Dark and on an overcast morning for
  Light (no logo); 1920×1080, 2560×1440, 3840×2160 and 3440×1440 (ultrawide)
- **Konsole** colour schemes and profiles
- **Top panel**: launcher, task manager, centred clock, KVitals system stats and system tray, with an
  optional "Fancy" look via the Panel Colorizer widget
- **Fastfetch colours**: recolours your own Fastfetch setup, keeping its layout and logo; or,
  if you choose it, the optional Waypoint Fastfetch design with the Waypoint logo
- **`waypoint`**: one command to switch everything between Dark and Light

## Install (no root needed)
    cd Waypoint-KDE-0.2.0
    ./install.sh            # preview: shows what will be installed and backed up; changes nothing
    ./install.sh --apply    # install; anything it replaces is moved to ~/waypoint-backup-<time>/
    ~/.local/bin/waypoint dark          # or: light
Then log out and back in once.

Options for the installer:

| Option | What it does |
|---|---|
| `--kvitals` | install the KVitals stats widget without asking (Arch-based systems, from the AUR) |
| `--panel` / `--no-panel` | set up the Waypoint top panel without asking / don't offer it |
| `--panel-colorizer` | also install Panel Colorizer (AUR) and give the panel the "Waypoint Fancy" look |
| `--no-fastfetch` | leave Fastfetch alone |
| `--fastfetch-design` | use the Waypoint Fastfetch design (Waypoint logo) instead of only recolouring yours; without it the installer asks, default no |
| `--no-autosync` | don't add the login helper described below |

On distributions **without** the AUR, install KVitals and Panel Colorizer from Plasma instead:
right-click the panel → Add or Manage Widgets → Get New → Download New Plasma Widgets.

For the app style, install **Kvantum** with your package manager
(Arch/Fedora: `kvantum`, openSUSE: `kvantum-qt6`, Debian/Ubuntu: `qt6-style-kvantum`).

## The `waypoint` command
    waypoint dark | light               switch the whole theme (also Kvantum, Konsole and Fastfetch)
    waypoint panel                      preview the top panel
    waypoint panel --apply [--fancy]    build the top panel on your main screen (backs up first)
    waypoint panel --restore            put your previous panels back
    waypoint dim on | off | N           fade unfocused windows (N = 0–100; Dark 20, Light 10)
    waypoint sync                       match Kvantum, Konsole and Fastfetch to the current Waypoint variant

A Global Theme on its own can't choose the Kvantum theme, Konsole's default profile or
Fastfetch colours. So the installer adds a small login helper (`waypoint watch`, listed in
System Settings → Autostart as "Waypoint sync"): whenever you switch to Waypoint Dark or Light,
including from System Settings → Global Theme, it switches those too. It does nothing while
another colour scheme is active, and it leaves a Konsole profile of your own alone.
Run `waypoint sync` to do the same by hand. Your panel layout is only changed when you ask for it.

## Fastfetch
Waypoint never replaces your Fastfetch config. It only recolours it, keeping your logo, modules,
layout and comments; on a system with no config it starts from Fastfetch's default layout.
Works on any distro (needs Python 3):

    fastfetch/install-fastfetch-colours.sh            # preview
    fastfetch/install-fastfetch-colours.sh --apply    # recolour (the original is kept)
    fastfetch/install-fastfetch-colours.sh --restore  # put your original back

Optional **Waypoint design**: the Waypoint logo (amber chevron over the W) with a short module
list (OS, kernel, uptime, desktop, theme, icons, terminal, CPU, GPU, memory). Your current config
is backed up first and `--restore` brings it back:

    fastfetch/install-fastfetch-colours.sh --design --apply

Fastfetch itself is never required. If it isn't installed, the script shows the install command
for your distro and only runs it if you say yes.

## Login screen (SDDM)
System Settings → Colors & Themes → Login Screen (SDDM) → select **Breeze** →
**Apply Plasma Settings…** (copies colours, cursor and font) → choose the Crescent or Outpost wallpaper
as background if you like → Apply.

## Test the splash screen without logging out
    ksplashqml --test --window org.waypoint.dark

## Undo
- Panels: `waypoint panel --restore`
- Fastfetch: `fastfetch/install-fastfetch-colours.sh --restore`
- Everything else: choose Breeze parts in System Settings → Colors & Themes, and copy anything
  you want back from `~/waypoint-backup-<time>/`.

## What's inside
| Folder | Installs to |
|---|---|
| look-and-feel | ~/.local/share/plasma/look-and-feel |
| plasma/desktoptheme | ~/.local/share/plasma/desktoptheme |
| color-schemes | ~/.local/share/color-schemes |
| aurorae/themes | ~/.local/share/aurorae/themes |
| Kvantum | ~/.config/Kvantum |
| icons, cursors | ~/.local/share/icons |
| hicolor | ~/.local/share/icons/hicolor (only the Waypoint logo icons) |
| wallpapers | ~/.local/share/wallpapers |
| konsole | ~/.local/share/konsole |
| panel, panel-colorizer | ~/.local/share/waypoint, ~/.config/panel-colorizer/presets |
| fastfetch | changes colours in your own Fastfetch config (fastfetch/design: the optional Waypoint design) |
| bin/waypoint | ~/.local/bin |
| autostart | ~/.config/autostart (the "Waypoint sync" login helper) |

## Licences
See LICENSE. In short: Waypoint's own work is GPL-3.0-or-later; the Kvantum style derives from
KvArc (GPL-3.0); the cursors derive from Breeze (GPL-2.0-or-later); the Plasma Styles and folder
icons derive from Breeze (LGPL); the wallpapers are CC BY-SA 4.0. The Waypoint name and logo
are DigitalCohesion's brand (see LICENSE).
