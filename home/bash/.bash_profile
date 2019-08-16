# only sources these if they exist
[[ -r ~/.git-completion.bash ]] && . ~/.git-completion.bash
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases

export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTCONTROL=ignorespace

# saves history while in tmux
export PROMPT_COMMAND='history -a'

export EDITOR="vi"
export VISUAL="vi"

# stop here if the shell is not interactive
# the substitution checks for the string "i"
# in the magic variable $-, which has the flags
# with which the shell was invoked
# ...sorry
if [ -n "${-##*i*}" ]; then
    return
fi

export PS1="\[$(color_code green)\]\u\[$(color_code reset)\]:\[$(color_code blue)\]\W\[$(color_code red)\] λ \[$(color_code reset)\]"

# have ssh-agent start automatically and make sure it dies automatically
if [ -z "$SSH_AUTH_SOCK" ]; then
    trap 'ssh-agent -k' EXIT
    eval $(ssh-agent)
    ssh-add
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="nvim"
export VISUAL="nvim"

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# these should overwrite anything above
[[ -r ~/.bash_profile.local ]] && . ~/.bash_profile.local

# tmux/screen code needs to be loaded after
# everything else. it looks like starting
# one of the sessions interrupts normal
# sourcing of bash_profile

# start tmux/screen or attach to an existing session
# only runs if we're not in an active tmux/screen session right now

[[ $TERM_PROGRAM = HyperTerm ]] && return

if which tmux >/dev/null 2>&1
then
    if [[ -z $TMUX && -z $STY ]]
    then
        # -d flag helps resize window
        # will automatically detach other clients (ie terminal windows)
        # from the session
        tmux attach -d >/dev/null || tmux new-session -s main
    fi
elif which screen >/dev/null 2>&1
then
    if [[ -z $TMUX && -z $STY ]]
    then
        if [[ $(screen -q -ls; echo $?) -le 9 ]]
        then
            screen -d -m -S main
            screen -S main -p 1 -X stuff "clear$(printf \\r)"
            screen -rd
        elif [[ $(screen -q -ls; echo $?) -ge 10 ]]
        then
            screen -d -R
        fi
    fi
fi
