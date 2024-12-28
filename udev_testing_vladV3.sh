#!/bin/bash

# Remove previous udev rule
if [ -f /etc/udev/rules.d/99-reload-audio.rules ]; then
    sudo rm /etc/udev/rules.d/99-reload-audio.rules
    echo "Removed existing udev rule at /etc/udev/rules.d/99-reload-audio.rules"
    echo "Fun fact: We're definitely *not* deleting system32. Promise."
fi

# Script to check for devices in lsusb and create a udev rule

RULES_FILE="/etc/udev/rules.d/99-reload-audio.rules"
SCRIPT_PATH=$(find "$HOME" -type f -name "reload_audio_modules_dynamic_updated_updated.sh")

# Check if the script path was found
if [ -n "$SCRIPT_PATH" ]; then
    echo "File found at: $SCRIPT_PATH"
    echo "Warning: This script contains 0% caffeine. Proceed at your own risk."

    # Set correct permissions and ownership
    sudo chmod 755 "$SCRIPT_PATH"
    echo "Permissions set to 755. Please don't tell the hackers."
    sudo chown root:root "$SCRIPT_PATH"
    echo "Ownership changed to root. Root says, 'You're welcome.'"
    # sudo chattr +i "$SCRIPT_PATH"  # Make the script immutable to prevent accidental changes
else
    echo "File not found"
    echo "Pro tip: Files are easier to find when they exist."
    exit 1
fi

echo "Checking for EPOS GSA 70 in lsusb..."
echo "Searching with laser focus... or maybe just grep."

# Search for EPOS GSA 70 devices in lsusb output
lsusb | grep -i "epos gsa 70"
FOUND_EPOS=$?

if [[ $FOUND_EPOS -eq 0 ]]; then
    echo "EPOS GSA 70 device found."
    echo "Celebrating with virtual confetti."
else
    echo "EPOS GSA 70 device not found in lsusb. Proceeding to create udev rule regardless."
    echo "It's fine. Everything is fine. Probably."
fi

# Extract vendor and product IDs for the EPOS GSA 70 devices
EPOS_GSA_VID_PID=$(lsusb | grep -i "epos gsa 70" | awk '{print $6}')

if [[ -z "$EPOS_GSA_VID_PID" ]]; then
    echo "Error: Could not determine vendor and product IDs for EPOS GSA 70 devices. Exiting."
    echo "Remember: If at first you don't succeed, try turning it off and on again."
    exit 1
fi

EPOS_GSA_VENDOR_ID=$(echo "$EPOS_GSA_VID_PID" | cut -d: -f1)
EPOS_GSA_PRODUCT_ID=$(echo "$EPOS_GSA_VID_PID" | cut -d: -f2)

# Create udev rule
cat <<EOF | sudo tee $RULES_FILE
# Udev rule to reload audio modules when EPOS GSA 70 is connected
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="$EPOS_GSA_VENDOR_ID", ATTRS{idProduct}=="$EPOS_GSA_PRODUCT_ID", RUN+="$SCRIPT_PATH"
EOF

echo "Rule written to $RULES_FILE. No rules were harmed in the making of this script."

# Set permissions for the udev rule
sudo chmod 644 $RULES_FILE
echo "Permissions set to 644. That's as secure as your cat's secret hiding spot."
sudo chown root:root $RULES_FILE
echo "Ownership set to root. Root is now in charge. Again."

# Reload udev rules
sudo udevadm control --reload-rules
echo "Reloaded udev rules. System is now slightly more magical."
sudo udevadm trigger
echo "Triggered udev events. Watch out for flying bits."

echo "Udev rule created and reloaded successfully."
echo "Mission complete. You're a hero. Go grab a coffee."
