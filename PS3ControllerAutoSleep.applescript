-- Copyright 2015 Google Inc. All Rights Reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http:--www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-- PSControllerAutoSleep
-- Disconnect PS3 Bluetooth controller when Mac OS runs screen saver
--
-- Author: timofey.basanov@gmail.com (Timothy Basanov)
-- Heavily based on:
-- http://darren.stanford.edu/serendipity/archives/139-Applescript-to-stop-mail.app-from-checking-when-screensaver-is-on.html
-- https://coderwall.com/p/fyfp0w/applescript-to-connect-bluetooth-headphones

set idleTime to (do shell script "ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}'") as number
-- Check time when Mac was not used for
-- http://stackoverflow.com/questions/17964660
if idleTime > 8 * 60 and idleTime < 10 * 60 then -- only do something if idle for some time, but not for long
	try
		tell application "System Events"
			tell application process "SystemUIServer"
				log "count number of controllers connected"
				set controllersCount to my CountControllerMenuItems()

				log "in case there are no controllers, nothing to do"
				if controllersCount is 0 then return

				log "ask for user confirmation first"
				set gaveUp to gave up of (display dialog "Looks like computer was inactive for quite some time.
I'm going to disconnect PlayStation controllers connected via bluetooth.

You have a 10 seconds timeout before I proceeed further." with title "Disconnect PlayStation controllers" buttons {"No, don't do it! I'm using them"} default button 1 giving up after 10)
				if gaveUp is not true then return

				log "disconnect all the controllers one by one"
				repeat controllersCount times
					my DisconnectController()
				end repeat
			end tell
		end tell
	on error errorString number errorNumber
		-- something wrong happened, let's ignore it! :)
		log errorString
	end try
end if

on GetBluetoothMenu()
	log "GetBluetoothMenu()"
	tell application "System Events"
		tell application process "SystemUIServer"
			return first item of (every menu bar item of menu bars where description is "bluetooth")
		end tell
	end tell
end GetBluetoothMenu

on GetControllerMenuItemsWhenMenuOpen(bluetooth)
	log "GetControllerMenuItemsWhenMenuOpen()"
	tell application "System Events"
		tell application process "SystemUIServer"
			return every menu item of menus of bluetooth whose name begins with "PLAYSTATION"
		end tell
	end tell
end GetControllerMenuItemsWhenMenuOpen

on CountControllerMenuItems()
	log "CountControllerMenuItems()"
	tell application "System Events"
		tell application process "SystemUIServer"
			set bluetooth to my GetBluetoothMenu()
			click bluetooth
			repeat with controller in my GetControllerMenuItemsWhenMenuOpen(bluetooth)
				-- dirty hack to flatten {{}}
				set counter to count of controller
				click bluetooth
				return counter
			end repeat
			return 0
		end tell
	end tell
end CountControllerMenuItems

on DisconnectController()
	log "DisconnectController()"
	tell application "System Events"
		tell application process "SystemUIServer"
			set bluetooth to my GetBluetoothMenu()
			click bluetooth
			set controllers to my GetControllerMenuItemsWhenMenuOpen(bluetooth)
			repeat with controller in controllers
				-- dirty hack to flatten {{}}
				if (count of controller) is 0 then
					exit repeat
				end if
				click (controller's first item)
				click (menu item "Disconnect" of controller's first item's menus)
				return
			end repeat
			click bluetooth
		end tell
	end tell
end DisconnectController
