pkg install autossh tmux -y
termux-wake-lock
tmux kill-session -t tunnel 2>/dev/null
tmux new-session -d -s tunnel 'autossh -M 0 -o "ServerAliveInterval 15" -o "ServerAliveCountMax 4" -o "ExitOnForwardFailure yes" -p 1128 -L 6080:localhost:6080 root@178.105.245.151 -N'
tmux ls
