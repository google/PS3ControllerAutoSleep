This is not an official Google product.

# PS3ControllerAutoSleep
Disconnects PS3 Bluetooth controller when Mac OS runs screen saver.
Fixes a known problem: Mac OS can not sleep when PS3 Controller is connected via bluetooth.

Known to work on English Mac OS X Mavericks and Yosemite.

# Installation Instructions
1. Open _Security & Privacy_ in _System Preferences_
1. Select _Accessibility_ and enable _PS3ControllerAutoSleep_ application
1. Open _Users & Groups_ in _System Preferences_
1. Check your _Login Items_ and drag & drop _PS3ControolerAutoSleep_ application into this list
1. Use _Hide_ checkbox to not to show this app in the Dock
1. Open _Bluetooth_ in _System Preferences_
1. Verify that Bluetooth is shown in menu bar
1. Don't forget to restart, or at least log out once

## Known issue
I have not found a way to save an app as an editable file and make it stay open.
I've created a wrapper app, which continues its execution:

		on idle
			run script (((POSIX path of (path to me)) & "../PS3ControllerAutoSleep.applescript") as POSIX file)
			return 60
		end idle
