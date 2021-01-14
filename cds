#!/usr/bin/bash

# arg1 -> base dir
# arg2 -> session name (default is "default")


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

sess_exists=$(tmux ls | grep "$sess")
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
	#tmux send-keys -t "$sess" "cd $base" C-m
fi


#echo $sess
#
#thing=$(tmux ls | grep attached)
#echo "$thing"

#IFS=':' read -ra boop <<< "$thing"
#for i in "${ADDR[@]}"; do
#    echo "$i"
#    echo "here"
#done

#(tmux a -t "$sess" || tmux new-sess -s "$sess")



