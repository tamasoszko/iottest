#!/bin/bash

SRC=*.py
DEST=workspace/test/
HOST=192.168.1.11

scp $SRC pi@$HOST:$DEST
