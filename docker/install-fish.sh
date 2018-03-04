#!/bin/bash
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list
apt-get update
wget -qO - http://download.opensuse.org/repositories/shells:fish:release:2/Debian_8.0/Release.key | apt-key add -
apt-get update
apt-get install -y fish

mkdir /root/.config/
touch /root/.config/config.fish
echo "source (conda info --root)/etc/fish/conf.d/conda.fish" > ~/.config/config.fish
