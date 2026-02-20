#!/usr/bin/bash

flameshot gui --raw | tesseract -l rus stdin stdout | xclip -in -selection clipboard

