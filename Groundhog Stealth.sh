#!/bin/sh
printf '\033c\033]0;%s\a' Groundhog Stealth
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Groundhog Stealth.x86_64" "$@"
