#!/bin/sh
set -e

if [ "$1" = "purge" ]; then
	. /usr/share/debconf/confmodule
	db_purge
	rm /etc/anarchy-pulse-agent.conf
fi
