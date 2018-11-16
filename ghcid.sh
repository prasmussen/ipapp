#!/bin/bash

ghcid --command "stack ghci --main-is ipapp:exe:ipapp" -T 'writeFile "ghcid.log" "ok"'
