#!/bin/bash

ls *.fnl | entr sh -c 'fennel --compile main.fnl > main.lua; fennel --compile game.fnl > game.lua'