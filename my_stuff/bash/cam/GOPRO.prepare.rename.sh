#!/bin/bash
if [ x$1 == xold ]; then
	for a in *; do n=${a:4:4};m=${a:0:4};mv $a ${n}${m}.mp4; done
	exit 0
fi;

for a in *; do mv $a $( stat $a -c %Y.%n ); done
