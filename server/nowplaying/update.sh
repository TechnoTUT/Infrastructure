#!/bin/bash
cd ~/nowplaying_dj
git git fetch
git reset --hard origin/main
git merge origin/main
\cp -f ./* /usr/share/nginx/html/