#!/bin/sh

sleep 2
easyeffects --gapplication-service &
sleep 1
pamixer --source $(pamixer --list-sources | awk '/Blue/ {print $1}') --set-volume 40
