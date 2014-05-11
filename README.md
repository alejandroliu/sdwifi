
# Automated Uploads with Transcend Wi-Fi SD Card

This is based on this article
[Transcend WIFI SD Hacks](https://www.pitt-pladdy.com/blog/_20140202-083815_0000_Transcend_Wi-Fi_SD_Hacks_CF_adaptor_telnet_custom_upload_/).

## Files

### SD only files

- autorun.sh (sd root)  
  Sets-up our environment.
- config.sh (.custom)  
  Configuration settings.

### root-fs files

- autoupload (.custom)  
  It is copied to `/bin`.  This script automatically uploads pictures
  to the configured server.  Runs once on start-up.
- busybox-armv5l (.custom)  
  Copied to `/sbin`.  Contains additional `busybox` functionality.

### DHCP extensions

- access.sh (.custom)  
  Starts background daemons if we are on trusted wireless nets.  It is
  added to the `/etc/dhcp.script`.
- ntpd.sh (.custom)  
  
### Host only files

- inst  
  This is a script used to copy working files to the sdcard.

# FTP Server

This script will automatically upload files to an FTP server.  The
server needs to be specially prepared.  Specifically under the
`ftp_path` directory you need to create sub-directories.  The
sub-directories need to be in the form:

    xx.xx.xx.xx.xx.xx

Where this is the MAC address of the WIFI card, in hex with dot (.)
separators and lowercase.

This directory has to be writeable to the FTP user.  Also, in that
directory, there should be two empty files:

    .state.0
	.state.1

These files should also be writeable to the FTP user.

# Configuring the client

Configuring the client is through editing the file `config.sh`.

# Basic Usage

Usage should be quite simple.  Simply turn on the camera within the
range of the trusted network.  Thing should happen automatically.

# Notes

Linux command to format SD card:

    sudo mkdosfs -n C00LPIX -v /dev/sdb1


# TODO

- document stop/resume and how we handle ungraceful shutdown
- include a status      (uploading ... date ... etc)
- 
