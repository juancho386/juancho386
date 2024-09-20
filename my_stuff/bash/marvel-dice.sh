#!/bin/bash
d1=(1 2 3 4 5 6)
d2=(1 2 3 4 5 6)
dm=(2 3 4 5 6 6)
echo "  Times value"
for a in ${d1[@]}; do
	for b in ${d2[@]}; do
		for c in ${dm[@]}; do
			r=$((a+b+c))
			echo $r
		done
	done
done | sort|uniq -c | sort -r

