#!/bin/sh
git add .

timestamp=$(date +%Y-%m-%dT%H:%M:%S)
git commit -m "Automated commit on $timestamp"
git push origin main