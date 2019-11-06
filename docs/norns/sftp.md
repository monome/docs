---
layout: page
permalink: /norns/sftp/
---

## sftp howto

Using cyberduck for SFTP access to Norns (macOS/windows)

This tutorial will help you connect Norns to another mac or windows computer, so that you can add and update scripts manually on the Norns filesystem.  It was written using Cyberduck 6.7.1, macOS 10.13.6, and norns 180828 on September 3, 2018.

Be careful when editing files on Norns.  If you delete files that Norns needs to run, it could corrupt the filesystem which would require a complicated reflash of the image to get back up and running. You most likely only want to be updating things in the dust subdirectory.

Alternatives to Cyberduck include Transmit for macOS and FileZilla for macOS, windows and linux.  While the screens will be different, the goal is the same, (to connect to Norns over the IP adress provided using SFTP/port 22).

1. If not already, start up Norns.  Navigate to SYSTEM / WIFI.  You can either use Norns in HOTSPOT mode, or by connecting to the same NETWORK that the computer you'll be downloading the SFTP client to is on. See the [norns docs](/docs/norns) for more information about WIFI setup.

2. Download Cyberduck.  You can find direct package installation for free from Cyberduck's website on the [changelog](https://cyberduck.io/changelog/) page.

3. Open Cyberduck and click the "Open Connection" button in the top left corner.

![](../image/sftp1.png)

4. Select SFTP from the dropdown at the top of the dialog that pops up.

![](../image/sftp2.png)

5. Enter the IP address that is displayed on the second line of the Norns SYSTEM / WIFI screen in the Server field of the dialog in Cyberduck.  Enter "we" in the Username field and "sleep" in the Password field.  The completed dialog should look like this (note that the IP address may be different, use the one given on _your_ Norns screen):

![](../image/sftp3.png)

6. If this is your first time connecting, an "Unknown Fingerprint" dialog will pop up, check "Always" and click Allow.

![](../image/sftp4.png)

The Norns filesystem should be displayed in the Cyberduck window.  You can add, delete, and rename files in this window, just like you would with an external USB flash drive in your computer's file explorer application.

Everything you need will be in the `dust` directory.
See the [file-tree](./#file-tree) overview in the main docs for an overview of what's what.

![](../image/sftp5.png)

### Troubleshooting

If things hang and do not connect, try to connect again after restarting Norns (and reconnecting on the SYSTEM / WIFI screen), as well as restarting Cyberduck.


### Credits

Thanks for jlmitch5 for this guide!
