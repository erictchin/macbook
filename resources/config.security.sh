
#!/bin/bash

# collected from various parts of the web
# some here: github.com/jamfprofessionalservices, some here: https://github.com/mathiasbynens/dotfiles

# Alot of these configs have been taken from the various places
# on the web, most from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# Color Variables
BLACK='\033[0;30m'
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

CURRENT_USER=$CURRENT_USER
CURRENT_USER_HOME=$HOME

# Ask for the administrator password upfront.
sudo -v

# Run a keep-alive to update the existing `sudo` timestamp until the script is done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

hardwareUUID=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | awk -F ": " '{print $2}')

###############################################################################
# OS Security
###############################################################################

# Enable Auto Update for MacOS
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Enable Auto Update for Apps from AppStore
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true

# Enable System Data Files and Security  Update Installs
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# Disable Bluetooth (if no paired device exists)
connectable="$( system_profiler SPBluetoothDataType | grep Connectable | awk '{print $2}' | head -1 )"
if [ "$connectable" = "Yes" ]; then
    sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -bool false
    killall -HUP blued
fi

# Show Bluetooth in menubar
open "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

# Set Time and Date Automatically
sudo systemsetup -setusingnetworktime on

# Restrict NTP Server to Loopback Interface
cp /etc/ntp-restrict.conf /etc/ntp-restrict_old.conf
sudo echo -n "restrict lo interface ignore wildcard interface listen lo" >> /etc/ntp-restrict.conf

# Enable screensaver after 20 minutes of inactivity
sudo defaults write $CURRENT_USER_HOME/Library/Preferences/ByHost/com.apple.screensaver."$hardwareUUID".plist idleTime -int 1200


# Disable Remote Apple Events
sudo systemsetup -setremoteappleevents off

# Disable Internet Sharing
/usr/libexec/PlistBuddy -c "Delete :NAT:AirPort:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
/usr/libexec/PlistBuddy -c "Add :NAT:AirPort:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist
/usr/libexec/PlistBuddy -c "Delete :NAT:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
/usr/libexec/PlistBuddy -c "Add :NAT:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist
/usr/libexec/PlistBuddy -c "Delete :NAT:PrimaryInterface:Enabled"  /Library/Preferences/SystemConfiguration/com.apple.nat.plist
/usr/libexec/PlistBuddy -c "Add :NAT:PrimaryInterface:Enabled bool false" /Library/Preferences/SystemConfiguration/com.apple.nat.plist

# Disable Screen Sharing and Remote Mangement
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Disable Print Sharing
/usr/sbin/cupsctl --no-share-printers

# Disable Remote Login
systemsetup -f -setremotelogin off

# Disable Bluetooth Sharing
/usr/libexec/PlistBuddy -c "Delete :PrefKeyServicesEnabled" $CURRENT_USER_HOME/Library/Preferences/ByHost/com.apple.Bluetooth."$hardwareUUID".plist
/usr/libexec/PlistBuddy -c "Add :PrefKeyServicesEnabled bool false" $CURRENT_USER_HOME/Library/Preferences/ByHost/com.apple.Bluetooth."$hardwareUUID".plist

# Don't wake for network access
sudo pmset -a womp 0

# Ensure Gatekeeper is enabled
sudo spctl --master-enable

# Enable Apple Firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2

# Enable Apple Firewall Stealth Mode (don't respond to ping, etc)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Disable Bonjour Advertising Service
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

# Show Wifi Status in menubar
open "/System/Library/CoreServices/Menu Extras/AirPort.menu"

# Disable NFS
sudo nfsd disable

# Restrict home directories
IFS=$'\n'
for userDirs in $( find /Users -mindepth 1 -maxdepth 1 -type d -perm -1 | grep -v "Shared" | grep -v "Guest" ); do
    chmod -R og-rwx "$userDirs"
done
unset IFS

# Ensure system wide apps have appropriate permissions
IFS=$'\n'
for apps in $( find /Applications -iname "*\.app" -type d -perm -2 ); do
    chmod -R o-w "$apps"
done
unset IFS

# Check for world writeable files in /System
IFS=$'\n'
for sysPermissions in $( sudo find /System -type d -perm -2 | grep -v "Public/Drop Box" ); do
    sudo chmod -R o-w "$sysPermissions"
done
unset IFS

# Enable OCSP and CRL certificate checking
sudo defaults write com.apple.security.revocation OCSPStyle -string RequireIfPresent
sudo defaults write com.apple.security.revocation CRLStyle -string RequireIfPresent
sudo defaults write $CURRENT_USER_HOME/Library/Preferences/com.apple.security.revocation OCSPStyle -string RequireIfPresent
sudo defaults write $CURRENT_USER_HOME/Library/Preferences/com.apple.security.revocation CRLStyle -string RequireIfPresent

# Disable the `root` account
sudo dscl . -create /Users/root UserShell /usr/bin/false

# Prompt for password when waking from sleep or screensaver
sudo defaults write $CURRENT_USER_HOME/Library/Preferences/com.apple.screensaver askForPassword -int 1

# Require admin password to access system-wide preferences
sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
/usr/libexec/PlistBuddy -c "Set :shared false" /tmp/system.preferences.plist
sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
rm /tmp/system.preferences.plist

# Disable ability to login to another user's active and locked session
sudo security authorizationdb write system.login.screensaver "use-login-window-ui"

# Disable fast user switching
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false

# Show login window as name and password (not prompted for with a username)
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Disable guest account
sudo defaults write /Library/Preferences/com.apple.loginwindow.plist GuestEnabled -bool false

# Disable allow guests to connect to shared folders
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool no
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool no

# Remove guest home folder
sudo rm -rf /Users/Guest || true

# disable automatic run of safe files in Safari
sudo defaults write $CURRENT_USER_HOME/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false

# reduce sudo timeout period
sudo echo "Defaults timestamp_timeout=0" >> /etc/sudoers

