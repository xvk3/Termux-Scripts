# Termux-Scripts #

#### rnvid.sh ####

Bash script to more easily and quickly watch a video and then choose to either rename or delete it

- [ ] Option to upload renamed video
- [x] Prevent duplicate names (append random string)
-- [ ] Keep extension after random string
- [ ] Continue to review videos util user exits
- [ ] Impement an alternative to the `read` command preventing Termux-API from appearing during the video
- [ ] Split the `termux-dialog` commands with `jq` to prevent errors

#### luip.sh ####

returns the IPv4 of a host, but when connected to specific WiFi networks can be configured to output a local IP address

#### wifi_name.sh ####

Prints the SSID of the current WiFi connection
