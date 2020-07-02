#!/data/data/com.termux/files/usr/bin/bash

# returns the IPv4 of a host, but when connected to specific WiFi networks can be configured to output a local IP address

# To prevent needlessly calling wifi_name and consequently 'termux-wifi-connectioninfo' this script checks the IP returned by the previous execution by connecting and running the $check and confirming the response by comparing it with the $proof variable.
# If the check and proof succeed output the IP used
# If the check and proof fail proceed with the program
#   1. Call wifi_name
#     a. If $wifi matches the current SSID = return $hcip
#   2. Use 'nslookup' on the $host
#   3. Output nslookup result
#   4. Update $last with the latest IP

# location of file containing previous IP
last="/data/data/com.termux/files/home/.fast_ip"

# when connected to $wifi output $hcip
wifi="Home Wifi"
hcip="10.0.0.1"

# user and hostname of target connection (used to verify ip)
user="xvk3"
host="mysshhost.com"
sshc="ssh -i ~/.ssh/id_ecdsa" 

# command and expected result for prooving connection
check="hostname"
proof="xvk3"

# Check Previous IP
pvip=$(cat $last)
resp=$($sshc $user@$pvip "${check}")
if [ "${resp}" == "${proof}" ]; then
  echo $pvip
  echo $pvip > $last
  exit 1
fi

# Check SSID
ssid=$(~/bin/wifi_name.sh)
if [[ "${ssid}" == "${wifi}" ]]; then
  echo $hcip
  echo $hcip > $last
  exit 0
fi

# Need to lookup IP
xvip=$(nslookup $host | grep -Po "(?<=Address\: )(\d+\.?)*")
echo $xvip
echo $xvip > $last
