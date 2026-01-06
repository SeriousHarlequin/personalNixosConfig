#!/usr/bin/env bash
set -xeuo pipefail

# 1. Detect or set your resolution and refresh rate
# Replace 1920, 1080, and 60 with your actual monitor specs
WIDTH=1920
HEIGHT=1080
REFRESH=60 

gamescopeArgs=(
    --adaptive-sync    # VRR support
    --hdr-enabled
    --mangoapp        # performance overlay
    --rt              # Real-time priority
    --steam           # Enable Steam integration features
    -e                # Important: Enables Steam Wayland/Overlay integration
    -W "$WIDTH"       # Output width
    -H "$HEIGHT"      # Output height
    -r "$REFRESH"     # CRITICAL: Forces the UI to run at this speed
    --allow-tearing   # Can reduce perceived input lag in UI
)

steamArgs=(
    -gamepadui        # The modern Deck UI
    -steamdeck        # Tells Steam it's running in "Deck Mode"
    -steamos          # Enables system-level power/display menus
)

mangoConfig=(
    cpu_temp
    gpu_temp
    ram
    vram
    fps
    frametime
)

# Clear LD_PRELOAD to avoid the common "lag bomb" stutter
export LD_PRELOAD=""
export MANGOHUD=1
export MANGOHUD_CONFIG="$(IFS=,; echo "${mangoConfig[*]}")"

# Use 'exec' to replace the shell process
exec gamescope "${gamescopeArgs[@]}" -- steam "${steamArgs[@]}"
