#!/usr/bin/bash

# arg1 -> tmux session name
# arg2 -> directory that tmux should start in
# arg3 -> command to run once session is attached (command gets sent to all open panes)


echo "creating new tmux session"
getopts s: session
sess=$OPTARG
getopts d: base_dir
base=$OPTARG
getopts c: attach
cmd=$OPTARG


if [ -z "$sess" ]
then
    sess="default"
fi

if [ -z "$base" ]
then
	base="./"
fi


echo session: $sess
echo base dir: $base
echo command: $cmd

sess_exists=$(tmux ls | awk -F: '{print $1}' | grep "$sess")

# assumes session does not already exist
if [ -z "$sess_exists" ]
then
	tmux new-sess -d -s "$sess"
	tmux split-window -h -t "$sess".0
	tmux split-window -v -t "$sess".0
	for pane in $(tmux list-panes -F "#P" -t "$sess"); do
		tmux send-keys -t "$sess".${pane} "cd $base" Enter
		tmux send-keys -t "$sess".${pane} "clear" Enter
		if [[ ! -z "$cmd" ]]
		then
			tmux send-keys -t "$sess".${pane} "$cmd" Enter
		fi
	done
	tmux a -t "$sess"

fi




