#!/usr/bin/env bash
# Waypoint — installer.
#   ./install.sh            preview: list what would be installed/backed up (changes nothing)
#   ./install.sh --apply    install for the current user (no root needed)
# Optional, added to either of the above:
#   --kvitals               install the KVitals stats widget (AUR, yay or paru) without asking
#                           (otherwise the installer checks for it and asks if it's missing)
#   --panel                 set up the Waypoint top panel without asking (it is offered anyway;
#                           your current panel is backed up first, undo with `waypoint panel --restore`)
#   --no-panel              don't set up the panel and don't ask
#   --panel-colorizer       optional fancy panel: install the Panel Colorizer widget (AUR) and style
#                           the Waypoint panel with its "Waypoint Fancy" preset (implies --panel)
#                           (the Waypoint presets are always copied, so you can load them later)
#   --no-autosync           don't add the small login helper that keeps Kvantum, Konsole and Fastfetch
#                           in step when you pick Waypoint Dark/Light in System Settings
#   --no-fastfetch          leave Fastfetch alone (otherwise its colours are set to Waypoint's;
#                           your Fastfetch design is kept, undo: fastfetch/install-fastfetch-colours.sh --restore)
#   --fastfetch-design      optional: use the Waypoint Fastfetch design (Waypoint logo + module list)
#                           instead of only recolouring yours. Your config is backed up first and
#                           comes back with fastfetch/install-fastfetch-colours.sh --restore.
#                           Without this flag the installer asks (default: no).
# Every existing item it replaces is moved to ~/waypoint-backup-<timestamp>/ first.
set -euo pipefail
SELF="$(readlink -f "$0")"
cd "$(dirname "$SELF")"

APPLY=0; WANT_KV=0; WANT_PANEL=0; NO_PANEL=0; NO_FF=0; WANT_PC=0; NO_SYNC=0; FF_DESIGN=0
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=1 ;;
    --kvitals) WANT_KV=1 ;;
    --panel) WANT_PANEL=1 ;;
    --no-panel) NO_PANEL=1 ;;
    --no-fastfetch) NO_FF=1 ;;
    --fastfetch-design) FF_DESIGN=1 ;;
    --no-autosync) NO_SYNC=1 ;;
    --panel-colorizer) WANT_PC=1; WANT_PANEL=1 ;;
    -h|--help) sed -n '2,23p' "$SELF" | sed 's/^# //; s/^#$//'; exit 0 ;;
    *) echo "unknown option: $arg  (see ./install.sh --help)" >&2; exit 2 ;;
  esac
done

widget_installed() {   # $1 = plasmoid id
  for d in /usr/share/plasma/plasmoids "${XDG_DATA_HOME:-$HOME/.local/share}/plasma/plasmoids"; do
    [ -d "$d/$1" ] && return 0
  done
  return 1
}

# aur_widget <label> <plasmoid id> <AUR package> <store search name>
aur_widget() {
  local label="$1" id="$2" pkg="$3" store="$4"
  echo
  if widget_installed "$id"; then echo "$label: already installed."; return 0; fi
  local AUR=""; for h in yay paru; do command -v $h >/dev/null 2>&1 && { AUR=$h; break; }; done
  if [ -z "$AUR" ]; then
    echo "$label: no AUR helper (yay or paru) found. Install it from Plasma instead:"
    echo "  right-click the panel → Add or Manage Widgets → Get New → Download New Plasma Widgets → '$store'"
    return 1
  elif [ $APPLY = 1 ]; then
    echo "$label: installing $pkg with $AUR (it will ask for your password)..."
    if ! $AUR -S --needed "$pkg"; then
      echo "$label: install failed. If you saw '404' errors, your package list is out of date —"
      echo "  run  sudo pacman -Syu  and then run this installer again."
      return 1
    fi
  else
    echo "$label: would install $pkg with $AUR"
  fi
}
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/waypoint-backup-$STAMP"

# source -> destination parent
ITEMS=(
  "plasma/desktoptheme/waypoint-dark|$DATA/plasma/desktoptheme"
  "plasma/desktoptheme/waypoint-light|$DATA/plasma/desktoptheme"
  "color-schemes/Waypoint-Dark.colors|$DATA/color-schemes"
  "color-schemes/Waypoint-Light.colors|$DATA/color-schemes"
  "aurorae/themes/Waypoint-Dark|$DATA/aurorae/themes"
  "aurorae/themes/Waypoint-Light|$DATA/aurorae/themes"
  "icons/Waypoint|$DATA/icons"
  "cursors/Waypoint-Cursors-Dark|$DATA/icons"
  "cursors/Waypoint-Cursors-Light|$DATA/icons"
  "wallpapers/Waypoint-Crescent|$DATA/wallpapers"
  "wallpapers/Waypoint-Outpost|$DATA/wallpapers"
  "look-and-feel/org.waypoint.dark|$DATA/plasma/look-and-feel"
  "look-and-feel/org.waypoint.light|$DATA/plasma/look-and-feel"
  "konsole/WaypointDark.colorscheme|$DATA/konsole"
  "konsole/WaypointLight.colorscheme|$DATA/konsole"
  "konsole/WaypointDark.profile|$DATA/konsole"
  "konsole/WaypointLight.profile|$DATA/konsole"
  "Kvantum/WaypointDark|$CONF/Kvantum"
  "Kvantum/WaypointLight|$CONF/Kvantum"
  "bin/waypoint|$HOME/.local/bin"
  "panel/waypoint-panel.js|$DATA/waypoint"
  "panel-colorizer/Waypoint Fancy|$CONF/panel-colorizer/presets"
  "panel-colorizer/Waypoint|$CONF/panel-colorizer/presets"
  "panel-colorizer/Waypoint Cards|$CONF/panel-colorizer/presets"
  "panel-colorizer/Waypoint Islands|$CONF/panel-colorizer/presets"
)
# the Waypoint logo also goes into the standard fallback icon theme (hicolor), so the launcher and
# app icon still show when another icon theme is in use. Only these files; hicolor is shared.
while IFS= read -r f; do
  ITEMS+=("$f|$DATA/icons/$(dirname "$f")")
done < <(cd . && find hicolor -type f | sort)
# login helper: switches Kvantum/Konsole/Fastfetch when the colour scheme changes to Waypoint's
[ $NO_SYNC = 0 ] && ITEMS+=("autostart/waypoint-sync.desktop|$CONF/autostart")

echo "Waypoint installer — $([ $APPLY = 1 ] && echo APPLY || echo 'PREVIEW (nothing will change; use --apply)')"
for entry in "${ITEMS[@]}"; do
  src="${entry%%|*}"; parent="${entry##*|}"; dest="$parent/$(basename "$src")"
  [ -e "$src" ] || { echo "  missing in package: $src" >&2; exit 1; }
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  replace  $dest   (old copy -> $BACKUP${dest#$HOME})"
    if [ $APPLY = 1 ]; then
      mkdir -p "$(dirname "$BACKUP${dest#$HOME}")"
      mv "$dest" "$BACKUP${dest#$HOME}"
    fi
  else
    echo "  install  $dest"
  fi
  if [ $APPLY = 1 ]; then
    mkdir -p "$parent"
    cp -R "$src" "$parent/"    # fresh file dates (Plasma caches theme images by date)
  fi
done

# ---- companion widget: always checked; offered if missing ----
# Waypoint's panel uses one community widget, KVitals (the system stats). If it's missing,
# offer to install it from the AUR. --kvitals answers "yes" in advance; without a terminal
# nothing is asked.
ask_yes() { [ -t 0 ] || return 1; local r; read -r -p "$1 [Y/n] " r; [ -z "$r" ] || [[ "$r" =~ ^[Yy] ]]; }
ask_no()  { [ -t 0 ] || return 1; local r; read -r -p "$1 [y/N] " r; [[ "$r" =~ ^[Yy] ]]; }

companion() {   # <label> <plasmoid id> <AUR pkg> <want flag> <what it does>
  local label="$1" id="$2" pkg="$3" want="$4" what="$5"
  if widget_installed "$id"; then
    echo "  $label: installed."
    return 0
  fi
  if [ $APPLY = 0 ]; then
    echo "  $label: NOT installed ($what) — the installer will offer to install it."
    return 0
  fi
  if [ "$want" = 1 ] || ask_yes "  $label is not installed ($what). Install it now from the AUR?"; then
    aur_widget "$label" "$id" "$pkg" "$label" || true
  else
    echo "  $label: skipped. Install later with  ./install.sh --apply --kvitals"
  fi
}

# ---- Fastfetch: keep the user's design, only the colours become Waypoint's ----
echo
if [ $NO_FF = 1 ]; then
  echo "Fastfetch: left alone (--no-fastfetch)."
elif [ $APPLY = 1 ]; then
  # optional Waypoint design: only with --fastfetch-design or a "yes" here (default no)
  if [ $FF_DESIGN = 0 ] && command -v fastfetch >/dev/null 2>&1 && \
     ask_no "Fastfetch: use the Waypoint design (Waypoint logo)? Your own config is backed up. (No = keep your design, Waypoint colours only)"; then
    FF_DESIGN=1
  fi
  DESIGNARG=""; [ $FF_DESIGN = 1 ] && DESIGNARG="--design"
  echo "Fastfetch $([ $FF_DESIGN = 1 ] && echo 'design (Waypoint logo)' || echo colours):"
  sh fastfetch/install-fastfetch-colours.sh --apply --quiet $DESIGNARG || echo "  Fastfetch step failed; run fastfetch/install-fastfetch-colours.sh --apply $DESIGNARG later."
else
  sh fastfetch/install-fastfetch-colours.sh --quiet $( [ $FF_DESIGN = 1 ] && echo --design ) | sed 's/^/  /' || true
  [ $FF_DESIGN = 0 ] && echo "  (Optional: --fastfetch-design uses the Waypoint logo design instead; the installer also asks.)"
fi

echo
echo "Companion widget:"
companion "KVitals" org.kde.plasma.kvitals plasma6-applets-kvitals-git "$WANT_KV" "the panel's CPU/RAM/GPU/network stats"
if [ $WANT_PC = 1 ]; then
  companion "Panel Colorizer" luisbocanegra.panel.colorizer plasma6-applets-panel-colorizer 1 "optional: styles the panel as 'Waypoint Fancy'"
fi

if [ $APPLY = 1 ]; then
  rm -f "$HOME/.cache/icon-cache.kcache"
  # Plasma keeps rendered copies of Plasma Style graphics; drop Waypoint's so updates show up
  rm -f "$HOME"/.cache/plasma_theme_waypoint-*.kcache "$HOME"/.cache/ksvg-elements* 2>/dev/null || true
  chmod +x "$HOME/.local/bin/waypoint"
  if [ $NO_SYNC = 0 ] && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] && command -v dbus-monitor >/dev/null 2>&1; then
    ( nohup "$HOME/.local/bin/waypoint" watch >/dev/null 2>&1 & )   # starts now; at login from autostart
  fi
  echo
  echo "Installed. Backups (if any): $BACKUP"
  if ! command -v kvantummanager >/dev/null 2>&1; then
    echo "NOTE: Kvantum is not installed; it gives apps the Waypoint style. Install it with your package manager:"
    echo "  Arch: kvantum   Fedora: kvantum   openSUSE: kvantum-qt6   Debian/Ubuntu: qt6-style-kvantum"
  fi
  echo "Next: run  waypoint dark   (or light), then log out and back in once."
  echo "(If 'waypoint' is not found, run ~/.local/bin/waypoint dark)"
  # The Waypoint top panel is part of the default install: offered (default yes) unless --no-panel.
  if [ $WANT_PANEL = 0 ] && [ $NO_PANEL = 0 ] && \
     ask_yes "Set up the Waypoint top panel now? (replaces your current top panel; it's backed up first)"; then
    WANT_PANEL=1
  fi
  if [ $WANT_PANEL = 1 ]; then
    echo
    echo "Building the Waypoint top panel..."
    FANCYARG=""; [ $WANT_PC = 1 ] && FANCYARG="--fancy"
    "$HOME/.local/bin/waypoint" panel --apply $FANCYARG || echo "Panel step failed; run  ~/.local/bin/waypoint panel --apply $FANCYARG  after logging in to Plasma."
  else
    echo "Tip: waypoint panel --apply sets up the Waypoint top panel any time."
  fi
  if [ $WANT_PC = 0 ]; then
    echo "Optional fancy panel: ./install.sh --apply --panel-colorizer  (or, with Panel Colorizer installed,"
    echo "  waypoint panel --apply --fancy; the presets are also in Panel Colorizer's Presets tab)."
  fi
else
  echo
  [ $NO_PANEL = 0 ] && { echo "Then offers to build the Waypoint top panel:"; bash bin/waypoint panel $( [ $WANT_PC = 1 ] && echo --fancy ) | sed 's/^/  /'; }
  echo "Preview only. Run ./install.sh --apply $( [ $WANT_KV = 1 ] && printf -- '--kvitals ' )$( [ $WANT_PC = 1 ] && printf -- '--panel-colorizer ' )$( [ $WANT_PANEL = 1 ] && printf -- '--panel ' )$( [ $NO_PANEL = 1 ] && printf -- '--no-panel' ) to install."
fi
