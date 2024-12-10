#!/bin/bash

# Function to check if a service is active
is_service_active() {
    systemctl is-active --quiet "$1"
}

# Stop audio services
echo "Stopping audio services..."
if is_service_active "pipewire.service"; then
    systemctl --user stop pipewire.service pipewire-pulse.service
    echo "Stopped PipeWire services."
fi

if is_service_active "pulseaudio.service"; then
    systemctl --user stop pulseaudio.service
    echo "Stopped PulseAudio services."
fi

# Identify all loaded kernel audio modules
echo "Identifying loaded kernel audio modules..."
AUDIO_MODULES=$(lsmod | awk '/^snd_/ {print $1}')
if [ -z "$AUDIO_MODULES" ]; then
    echo "No audio-related modules found."
    exit 1
fi

echo "Found audio modules: $AUDIO_MODULES"

# Append the identified modules to this script
SCRIPT_PATH=$(realpath "$0")
echo "Appending identified modules to the script for future use..."
echo -e "\n# Identified audio modules on $(date):\n# $AUDIO_MODULES" >> "$SCRIPT_PATH"

# Unload audio modules
echo "Unloading kernel audio modules..."
for MODULE in $AUDIO_MODULES; do
    echo "Unloading module: $MODULE"
    sudo modprobe -r "$MODULE" || echo "Failed to unload $MODULE"
done

# Reload audio modules
echo "Reloading kernel audio modules..."
for MODULE in $AUDIO_MODULES; do
    echo "Reloading module: $MODULE"
    sudo modprobe "$MODULE" || echo "Failed to reload $MODULE"
done

# Start audio services
echo "Starting audio services..."
if systemctl list-unit-files | grep -q "pipewire.service"; then
    systemctl --user start pipewire.service pipewire-pulse.service
    echo "Started PipeWire services."
elif systemctl list-unit-files | grep -q "pulseaudio.service"; then
    systemctl --user start pulseaudio.service
    echo "Started PulseAudio service."
fi

echo "Audio modules reloaded successfully."

