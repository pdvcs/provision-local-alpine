@echo off
if "%1"=="" goto novm
set vmname=%1

echo removing DVD from VM's optical drive...
vboxmanage storageattach %vmname% --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
ahk alpine-postinstall.ahk

goto endofscript

:novm
echo Please specify a VM Name.
echo Usage: postinstall.cmd vmname

:endofscript
