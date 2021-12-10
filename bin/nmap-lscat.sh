#!/usr/bin/env bash

locate .nse | xargs grep categories | grep -oP '".*?"' | sort -u
