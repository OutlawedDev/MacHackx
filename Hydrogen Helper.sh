#!/bin/bash
sudo -v || exit 1

osascript <<'APPLESCRIPT'
use scripting additions

property RBX_APP        : "/Applications/Roblox.app"
property HYD_APP        : "/Applications/Hydrogen-M.app"
property HYD_URL        : "https://0ai4bbbahf.ufs.sh/f/4fzhZqSSYIjmaQcw2hMCuIoXRdv5E3iwKj1g7S8GWLOxkpfJ"

-- Improved function for shell command execution
on sh(cmd)
    try
        return do shell script cmd
    on error e
        return "[ERROR] " & e
    end try
end sh

-- Open Roblox with animation
on openRoblox()
    display dialog "Opening Roblox..." buttons {"Cancel"} default button "Cancel" giving up after 5
    if sh("test -x " & quoted form of (RBX_APP & "/Contents/MacOS/RobloxPlayer") & " && echo OK") ≠ "OK" then
        display alert "Cannot open Roblox" message "Roblox.app missing or broken." buttons {"OK"} as critical
    else
        display dialog "Launching Roblox..." giving up after 2
        sh("open -a " & quoted form of RBX_APP)
    end if
end openRoblox

-- Clear Roblox cache with progress bar
on clearCache()
    display dialog "Clearing Roblox cache..." buttons {"Cancel"} default button "Cancel" giving up after 2
    do shell script "rm -rf ~/Library/Application\\ Support/Roblox"
    do shell script "rm -rf ~/Library/Caches/com.roblox.Roblox"
    display dialog "Roblox cache cleared." buttons {"OK"} default button "OK"
end clearCache

-- Uninstall both Roblox & Hydrogen with animated progress
on uninstallAll()
    display dialog "Uninstalling Roblox & Hydrogen-M..." buttons {"Cancel"} default button "Cancel" giving up after 3
    do shell script "rm -rf " & quoted form of RBX_APP
    do shell script "rm -rf " & quoted form of HYD_APP
    do shell script "rm -rf ~/Library/Application\\ Support/Roblox"
    do shell script "rm -rf ~/Library/Caches/com.roblox.Roblox"
    display dialog "Uninstalled Roblox and Hydrogen-M (if present)." buttons {"OK"} default button "OK"
end uninstallAll

-- Reinstall both (Roblox & Hydrogen) with notification
on reinstallBoth()
    display dialog "Reinstalling Roblox (this will also reinstall Hydrogen)..." buttons {"Cancel"} default button "Cancel" giving up after 2
    uninstallAll()
    installHydrogen()
    display dialog "Reinstallation complete!" buttons {"OK"} default button "OK"
end reinstallBoth

-- Install Hydrogen-M with terminal progress
on installHydrogen()
    set HYD_CMD to "curl -fsSL " & HYD_URL & " | bash"
    tell application "Terminal"
        activate
        do script HYD_CMD
    end tell
    display notification "Hydrogen-M is running in Terminal" with title "Hydrogen Helper"
end installHydrogen

-- System Requirements Check with more friendly UI
on checkSysReq()
    set v to system version of (system info)
    set arch to do shell script "uname -m"
    if v < "11.0" then
        display dialog "macOS 11+ required. You’re on " & v buttons {"OK"} default button "OK"
    else
        display dialog "System meets requirements:" & return & "macOS " & v & return & "CPU: " & arch buttons {"OK"} default button "OK"
    end if
end checkSysReq

-- Fix Sudden Close dialog animation
on fixSuddenClose()
    display dialog "If Hydrogen-M closes suddenly, try the following:" & return & "1) Redownload Hydrogen." & return & "2) Open Roblox and let it fully load." & return & "3) Restart your Mac." buttons {"OK"} default button "OK" with icon 2
end fixSuddenClose

-- Fix Roblox architecture if needed
on fixRobloxArch()
    set info to sh("file " & quoted form of (RBX_APP & "/Contents/MacOS/RobloxPlayer"))
    if info contains "arm64" or info contains "x86_64" then
        display dialog "Roblox architecture is correct." buttons {"OK"} default button "OK"
    else
        display dialog "RobloxPlayer architecture issue detected." & return & "1) Delete Roblox." & return & "2) Download the correct build from roblox.com." & return & "3) Install it (no Rosetta)." buttons {"OK"} default button "OK"
    end if
end fixRobloxArch

-- Fix Port Binding issue with dynamic UI
on fixPortBinding()
    openRoblox()
    delay 5
    if sh("lsof -iTCP -sTCP:LISTEN | grep -E '6969|6970|7069'") = "" then
        display dialog "No HTTP server on ports 6969–7069." buttons {"Install Hydrogen-M"} default button "Install Hydrogen-M"
        installHydrogen()
    else
        display dialog "Ports 6969–7069 are active. Hydrogen-M is loaded." buttons {"OK"} default button "OK"
    end if
end fixPortBinding

-- Password Prompt Fixer
on fixPasswordPrompt()
    display dialog "If the password prompt is hidden, enter your password and press Enter." buttons {"OK"} default button "OK"
end fixPasswordPrompt

-- Main helper and fixer menu with custom animations
on helperMenu()
    repeat
        set choice to choose from list {"Open Roblox", "Clear Roblox Cache", "Reinstall Roblox (with Hydrogen)", "Install Hydrogen-M", "Uninstall All", "Back"} with title "Hydrogen Helper" with prompt "Helper Options:"
        if choice is false or item 1 of choice = "Back" then return
        set sel to item 1 of choice
        if sel = "Open Roblox" then openRoblox()
        if sel = "Clear Roblox Cache" then clearCache()
        if sel = "Reinstall Roblox (with Hydrogen)" then reinstallBoth()
        if sel = "Install Hydrogen-M" then installHydrogen()
        if sel = "Uninstall All" then uninstallAll()
    end repeat
end helperMenu

on fixerMenu()
    repeat
        set choice to choose from list {"System Requirements Check", "Fix Sudden Close", "Fix Roblox Architecture", "Fix Port Binding", "Password Prompt Fix", "Back"} with title "Hydrogen Fixer" with prompt "Fixer Options:"
        if choice is false or item 1 of choice = "Back" then return
        set sel to item 1 of choice
        if sel = "System Requirements Check" then checkSysReq()
        if sel = "Fix Sudden Close" then fixSuddenClose()
        if sel = "Fix Roblox Architecture" then fixRobloxArch()
        if sel = "Fix Port Binding" then fixPortBinding()
        if sel = "Password Prompt Fix" then fixPasswordPrompt()
    end repeat
end fixerMenu

-- Main loop
repeat
    set page to choose from list {"Helper", "Fixer"} with title "Hydrogen Menu - from my-oblilyum   & inspiration from 109dg" with prompt "Select Page:"
    if page is false then exit repeat
    if item 1 of page = "Helper" then helperMenu()
    if item 1 of page = "Fixer" then fixerMenu()
end repeat

END
