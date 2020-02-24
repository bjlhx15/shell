#!/bin/bash

function test() {
    echo "进程id:$$"
    echo "参数个数: ${#}"
    echo "所有参数: $*"
    echo "所有参数: $@"
    for line in "$@"; do
        echo "$line"
    done
    echo "显示Shell使用的当前选项:$-"
}
test aa xx
echo "返回值：$?"
