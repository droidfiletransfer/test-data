#!/bin/sh
# Copyright (C) 2026 Aron Sommer. See LICENSE file for full license details.

# Prints which process holds the phone when the app says it cannot claim the
# interface. Double-click it, or run it from Terminal:
#
#   sh who-holds-the-phone.command
#
# "ptpcamerad" is macOS photo import, started by Preview, Photos, Image
# Capture or another photo app; macOS does not record which.

ioreg -lw0 -r -c IOUSBHostDevice | awk -F'"' '
  /"UsbExclusiveOwner" = "pid / { split($4, a, ", "); print "Held by: " a[2]; f = 1 }
  END { if (!f) print "Nothing is holding it." }'
