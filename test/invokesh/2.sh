#!/usr/bin/env bash

echo "子脚本2PID for 2.sh = $$"
echo "In 2.sh get variable A=$A from 1.sh"

A=2
export A

echo -e "子脚本2.sh默认A=2: variable A=$A\n"