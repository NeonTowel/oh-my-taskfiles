#!/usr/bin/env bash

# This is needed if you use 1Password on Windows and want to use ssh keys on WSL for signing git commits
#
# Additionally you need to configure Git to use ssh from Windows via WSL interoperability:
# core.sshcommand=/mnt/c/Windows/System32/OpenSSH/ssh.exe
# gpg.ssh.program=/mnt/c/Users/<username>/AppData/Local/1Password/app/8/op-ssh-sign.exe 
#
# You also need to download npiperelay.exe from https://github.com/jstarks/npiperelay
# on Windows (e.g. C:\Windows\System32\npiperelay.exe) and add it to your Linux PATH in WSL (e.g. /usr/local/bin).
# You can symlink it to /usr/local/bin, for example:
# sudo ln -s /mnt/c/<path to npiperelay.exe> /usr/local/bin/npiperelay.exe

# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
mkdir -p $HOME/.1password

# need `ps -ww` to get non-truncated command for matching
# use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    fi
    echo "Starting SSH-Agent relay..."
    # setsid to force new session to keep running
    # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi