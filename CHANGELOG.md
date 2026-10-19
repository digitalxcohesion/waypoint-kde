# Changelog

## 0.2.0
- Waypoint brand: the Waypoint logo is the panel's launcher icon, and a Waypoint app icon (dark and
  light tile, 32–512 px) is included, also in the hicolor theme so it shows with other icon themes
- New splash screen: the Outpost artwork with the Waypoint wordmark and an amber progress line
- New wallpaper "Outpost" in Dark (dusk) and Light (overcast morning), no logo, up to 3840×2160
  and ultrawide; Plasma picks the version that matches the colour scheme. Crescent stays the default
- Optional Waypoint Fastfetch design with the Waypoint logo (`--fastfetch-design`, or the
  installer asks; default no). Your own config is backed up and `--restore` brings it back
- Icons: grey Waypoint versions of the Dolphin, System Settings, Desktop and Home icons, which were
  drawn in the amber accent/highlight colour (Dolphin and System Settings in the panel, the Home
  folder) or as a colourful picture (the Desktop folder)

## 0.1.2
- Kvantum: "Transparent Dolphin view" is on by default (Dolphin's file view is translucent too)

## 0.1.1
- Waypoint Fancy (Panel Colorizer): lighter bar (black at 30%, was 55%) and slimmer sections
  (22 px, 4 px inside the bar). Re-apply with: waypoint panel --apply --fancy

## 0.1.0 — first public release
- Global Themes Waypoint Dark and Waypoint Light with splash screens
- Plasma Styles with flat task buttons; colour schemes; Aurorae window decorations with rounded
  top corners, an amber focus border and an amber close button
- Kvantum app style, folder icons, recoloured Breeze cursors, Konsole schemes and profiles
- "Crescent" wallpaper in Dark and Light, including an ultrawide size
- Waypoint top panel (launcher, task manager, centred clock, KVitals stats, tray), always placed on
  the main screen; optional "Waypoint Fancy" look with Panel Colorizer
- Fastfetch colour tool that keeps your own Fastfetch design
- `waypoint` command for Dark/Light switching, the panel and window dimming
- "Waypoint sync" login helper: choosing Waypoint Dark/Light anywhere (including System Settings)
  also switches the Kvantum theme, Konsole profile and Fastfetch colours
