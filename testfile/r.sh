#!/bin/bash
echo "hello"

cat "Languagefile" | while read line; do
	arr=(${line//,/ }) 
	echo ${arr[0]}
	# echo ${arr[@]}
	# echo $line | awk 'split($0, "#")'
done

# echo $var | awk '{printf("%d %s\n", split($0, var_arr, " "), var_arr[1]);}'