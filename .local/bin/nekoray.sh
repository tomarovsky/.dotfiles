#!/bin/bash

if pgrep -x "Throne" > /dev/null
then
    killall Throne
else
    throne -appdata &
fi

