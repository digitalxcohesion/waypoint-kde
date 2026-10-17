# Changelog

## 0.1.3
- Top panel: the task manager is replaced by app shortcuts (Plasma's Quick Launch): System Settings,
  Kate, Dolphin, Brave, Firefox and Konsole, skipping any that aren't installed (the default browser
  is used if neither Brave nor Firefox is). Drag apps onto it, or right-click it, to change the list.
  Want open windows back? `waypoint panel --apply --tasks`
- The panel command also clears away Waypoint panels made with app shortcuts on other screens

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
