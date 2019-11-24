#!/usr/bin/env bash

A=1

echo "执行调用之前进程Id exec/source/fork: PID for 1.sh = $$"

export A
echo "In 1.sh: variable A=$A"

case $1 in
        exec)
                echo -e "==> using exec…\n"
                exec ./2.sh ;;
        source)
                echo -e "==> using source…\n"
                . ./2.sh ;;
        *)
                echo -e "==> using fork by default…\n"
                ./2.sh ;;
esac

echo "执行调用之后进程Id exec/source/fork: PID for 1.sh = $$"
echo -e "父脚本1.sh: variable A=$A\n"