# Bash Scripts for Resolving Common Issues

This repository contains a collection of Bash scripts I've created to address various issues I've encountered.

## Scripts

### `reload_audio_modules_dynamic.sh`
This script identifies which audio server (PipeWire or PulseAudio) is currently running, determines the loaded audio kernel modules, and then unloads and reloads them dynamically. It is useful for troubleshooting audio-related issues.

### Script Name: `reload_audio_modules_dynamic_updated.sh`
Similar with `reload_audio_modules_dynamic.sh` additionally, the script prints the specific audio kernel module that resolves the issue, providing clarity and helping with targeted troubleshooting.

## Usage
1. Clone this repository.
2. Make the script executable:
   ```bash
   chmod +x reload_audio_modules_dynamic.sh
4. Run the script using:
   ```bash
   ./reload_audio_modules_dynamic.sh
