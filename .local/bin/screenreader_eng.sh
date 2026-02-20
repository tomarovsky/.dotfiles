#!/usr/bin/bash

flameshot gui --raw | tesseract -l eng  stdin stdout | xclip -in -selection clipboard

