### (Mostly) Hands-free setup for an Alpine Linux VM on VirtualBox

This is a set of scripts for VirtualBox on Windows to set up
an Alpine Linux VM. Edit `provision-alpvm.cmd` to suit your system.

### Requirements

1. VirtualBox 5
2. [AutoHotKey](https://autohotkey.com/) (`ahk` must be in your PATH)
3. VirtualBox, `gohttp` and `tokrepl` need to be in your PATH:
  1. `tokrepl` is included in this repo.
  2. `gohttp` can be obtained from [https://github.com/itang/gohttp](https://github.com/itang/gohttp).
  3.  To compile `gohttp` and `tokrepl`, you need [Go for Windows](https://golang.org/dl/).

### Usage

Once you've edited it, type `provision-alpvm.cmd` to begin.
