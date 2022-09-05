#!/bin/zsh

# Remove cached named pipe
rm -rf response
# Create new named pipe
mkfifo response

function handlePost {
	echo $1	
}

function handleRequest {
	# 1) process the request
	# 2) Route request to the correct handler
	# 3) Build a response based on the request
	# 4) Send the response to the named pipe (FIFO)
	while read line; do
		echo $line
		trline=`echo $line | tr -d '[\r\n]'`

		[ -z "$line" ] && break 
		
		HEADLINE_REGEX='(.*?)\s(.*?)\sHTTP.*?'
		[[ "$trline" =~ $HEADLINE_REGEX ]] && 
			REQUEST=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1 \2/")
	done

	# Different response each status
	case "$REQUEST" in
		"GET /") 
			RESPONSE="HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n</h1>PONG</h1>" ;;
		"POST /") handlePost $RESPONSE ;;

		*) RESPONSE="HTTP/1.1 404 NotFound\r\n\r\n\r\nNot Found" ;;
	esac
	
	echo -e $RESPONSE > response
}

function main {
	handleRequest
	
}
echo "Listening on...."
# On ubuntu
# cat response | nc -Nl 3000 | handleRequest 

# On macos
cat response | nc -vnl 3000 | handleRequest
