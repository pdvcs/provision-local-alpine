@echo off

rem get yyyymmdd date from a UK-locale (dd/mm/yyyy) date
for /f "tokens=1 eol=/ delims=/ " %%a     in ('date /t') do set dd=%%a
for /f "tokens=1,2 eol=/ delims=/ " %%a   in ('date /t') do set mm=%%b
for /f "tokens=1,2,3 eol=/ delims=/ " %%a in ('date /t') do set yyyy=%%c
for /f "tokens=1 eol=: delims=: " %%a     in ('time /t') do set hh=%%a
for /f "tokens=1,2 eol=: delims=: " %%a   in ('time /t') do set mi=%%b

set vmname=alpvm-%yyyy%%mm%%dd%-%hh%%mi%
set vmdisk="C:/Users/Public/Virtual-Machines/%vmname%/%vmname%_disk.vdi"

rem -*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*-
rem               Edit these variables to suit your setup!
rem -*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*-
rem

set localserver=192.168.1.67:8080
set rootpass=ChangeMe
set lanadapter="The Broadcom 802.11 Network Adapter provides wireless local area networking."
set source_iso=C:/Downloads/alpine-3.4.2-x86_64.iso

rem These are in MB:
set  vmramsize=1024
set vmdisksize=4096

rem
rem -*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*-


echo.
echo About to create Alpine Linux VM '%vmname%'
echo from %source_iso%
pause

echo.
echo Starting http server from current directory in the background...
start c:\bin\gohttp.exe
echo.

vboxmanage createvm --name %vmname% --ostype Linux26_64 --register

rem ## Setup machine with %vmramsize% MB RAM, 12MB VRAM
vboxmanage modifyvm %vmname% --memory %vmramsize% --vram 12 --acpi on --nic1 bridged --boot1 disk --boot2 dvd --boot3 none --pae off
vboxmanage modifyvm %vmname% --usb on --usbehci on --mouse usbtablet

rem ## Set "bridgeadapter1" to the value of the VM Host's network adapter you want to use, e.g. "eth0"
vboxmanage modifyvm %vmname% --bridgeadapter1 %lanadapter%

rem ## Setup machine with %vmdisksize% MB disk
vboxmanage createmedium disk --filename %vmdisk% --size %vmdisksize%

vboxmanage storagectl %vmname% --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storagectl %vmname% --name "IDE Controller"  --add ide  --controller PIIX4 --bootable on

vboxmanage storageattach %vmname% --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium %vmdisk%
vboxmanage storageattach %vmname% --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium %source_iso%

echo.
echo VM %vmname% has been set up, press any key to start it.
pause
vboxmanage startvm %vmname%

echo.
echo Generating local setup script...
tokrepl alpine-answerfile.sh.tmpl   alpine-answerfile.sh   +VMNAME=%vmname%
tokrepl alpine-local-setup.ahk.tmpl alpine-local-setup.ahk +VMNAME=%vmname%,+ROOTPASS=%rootpass%,+LOCALSERVER=%localserver%
tokrepl alpine-postinstall.ahk.tmpl alpine-postinstall.ahk +VMNAME=%vmname%,+ROOTPASS=%rootpass%,+LOCALSERVER=%localserver%

echo.
echo Press ENTER when you're at the login prompt and ready to run local setup...
pause
echo Running local setup...
ahk alpine-local-setup.ahk

echo.
echo Once OS installation completes, reboot the machine
echo (type "reboot" at the #-prompt).
echo Then, after it comes back up and you see the login prompt, type
echo.
echo postinstall.cmd %vmname%
echo.
