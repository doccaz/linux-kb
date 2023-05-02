#!/bin/bash

WINDOW=$(xdotool search --limit 1 --onlyvisible --classname google-chrome)

xdotool windowactivate ${WINDOW} \
	key ctrl+t \
	type --delay 110 chrome://net-internals/#dns

xdotool windowactivate ${WINDOW} \
	key Return


