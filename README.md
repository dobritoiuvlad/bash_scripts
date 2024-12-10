# Bash Scripts for Resolving Common Issues

This repository contains a collection of Bash scripts I've created to address various issues I've encountered.

## Scripts

### `reload_audio_modules_dynamic.sh`
This script identifies which audio server (PipeWire or PulseAudio) is currently running, determines the loaded audio kernel modules, and then unloads and reloads them dynamically. It is useful for troubleshooting audio-related issues.

## Usage
1. Clone this repository.
2. Run the script using:
   ```bash
   ./reload_audio_modules_dynamic.sh
