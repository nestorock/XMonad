ps -ef | pgrep xmobar | awk '{ print "echo kill -9 "$0; system("kill -9 "$0) }'

