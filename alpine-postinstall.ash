#!/bin/ash

# add important software
apk add sudo bash vim

export NEWUSER=pd

echo Adding a user called $NEWUSER with SHELL=bash...
adduser -s /bin/bash $NEWUSER

echo Adding $NEWUSER to sudoers...
echo -e "$NEWUSER\tALL=(ALL) ALL" >> /etc/sudoers

cat > ~/.profile <<__EOF1__
export EDITOR=vim
alias ll='ls -l'
alias lt='ls -lrth'
__EOF1__

cp ~/.profile ~pd/
chown pd:pd ~pd/.profile

cat > /etc/motd <<__EOF2__
Welcome to this auto-provisioned Alpine Linux VM!
__EOF2__

IP_ADDR=`ifconfig -a | awk '/Bcast/{print $2}' | cut -c 6-19`
echo You can now ssh to this machine using: $NEWUSER\@$IP_ADDR
