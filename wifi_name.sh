#!/data/data/com.termux/files/usr/bin/bash
termux-wifi-connectioninfo | grep -Po "(?<=\"ssid\"\: \")[^\"]+(?=\")"
