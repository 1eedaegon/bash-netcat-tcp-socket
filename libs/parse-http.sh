#!/bin/bash

function handleRequest() {
	while read line; do
		echo $line
		trline=`echo $line | tr -d '[\r\n]'`
		if [ -z "$trline" ]; then
			break
		fi
	done
	echo -e 'HTTP/1.1 200\r\n\r\n\r\n<h1>PONG</h1>' > response
}


