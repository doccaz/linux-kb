#!/bin/bash

WINDOW=$(xdotool search --limit 1 --onlyvisible --classname microsoft-edge)

xdotool windowactivate ${WINDOW} \
	key ctrl+t \
	type --delay 110 edge://settings/profiles/importBrowsingData
xdotool windowactivate ${WINDOW} \
	key Return


