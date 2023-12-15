---
layout: default
parent: help
grand_parent: norns
has_children: false
title: software help
nav_order: 2
---

# norns: software help
{: .no_toc }

Between this page and the search bar above, you should be able to solve most norns troubles that you'd run into.

If you need additional help, we're here for you! Please send an email to [help@monome.org](mailto:help@monome.org) using this format:

- *What issue did you experience?*
- *What steps are necessary to reproduce the issue?*
- *What additional hardware was connected to norns at the time of the issue? This includes controllers, wifi dongles, external hubs, etc.*
- *Please attach any output printed in [maiden](../maiden/) when the issue occurs*

If you're unable to supply concrete steps to reliably reproduce the issue, this will reduce our efficacy. Please understand if we point you to existing resources and ask you to verify additional info.

For support with specific scripts and libraries, please visit [lines](https://llllllll.co) and search for the script's thread.

<details open markdown="block">
  <summary>
    sections
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## system logs {#logs}

### gathering logs

In the event of an inexplicable issue, norns can dump the output of its logging mechanism to a text file. Logs capture the current and previous boots, which includes matron, SuperCollider, and operating system messages. Navigate to `SYSTEM > LOG` and press K3 -- this will create a file at `dust/data/system.log` which can then be copied via maiden or downloaded via [SMB](/docs/norns/wifi-files/#transfer) or [SFTP](/docs/norns/advanced-access/#sftp).

This information can be extremely helpful for community script authors, since it will reliably present any script-level errors, which can be difficult to capture through maiden's REPL window.

If you have a recurring issue which you believe is hardware or system failure, unrelated to any script, please include this file with your support request to help@monome.org

### deeper realtime debugging

We'll see errors from the running script print to [maiden's REPL](https://monome.org/docs/norns/maiden/#repl). But since maiden only allows us to scroll back through a limited history and occasionally will suppress errors (for example if we're [developing a mod](https://monome.org/docs/norns/community-scripts/#mods)), that sometimes won't be enough.

If we want to see a more encompassing realtime view of error messages from the running script, mods, and SuperCollider, we can log into our our norns directly via [SSH](https://github.com/docs/norns/advanced-access/#ssh) and issue the following command:

```
journalctl -f
```

This will not only show the last few system messages (including errors), but it will update as new ones occur.

When we're done, we can close the stream by hitting `Ctrl+C`. Be sure to also close the SSH connection to your norns by executing `exit`.

## recovering from freezes {#frozen}

If you experience a freeze that you can't recover from, there's a special button combination which will gently restart the software.

- First, press and hold K3

- While K3 is held, press and hold K2

- While K3 and K2 are held, press and hold K1

- Hold all three keys down for 10 seconds

*The order of the keypresses matters: K3 then add K2 then add K1*
{: .label}

If multiple attempts of this combination fail, these options are last resorts:

- standard norns have a little white button on the rear side which provides a hard reset

- shields do not have a reset button, so the only option is to pull power

Use the brute-force approach only if you cannot recover using the suggested method
{: .label .label-grey}

## adding + updating scripts {#update-scripts}

maiden (the web-based editor built into norns) features a [project manager](../maiden/#project-manager) to help facilitate project discovery, installation, and upgrades.

To add a script that isn't hosted on maiden, you can [fetch it using maiden's REPL](../maiden/#fetch.)

If you are updating a project through maiden's project manager that was not originally installed via the project manager, you will receive an error that the project cannot be found in the catalog. Please delete the previously installed version and reinstall through project manager, which establishes the necessary git files for future updates.

lines also has a dedicated [Library](https://llllllll.co/search?q=%23library%20tags%3Anorns) for projects tagged `norns`. In each project's thread, you'll find in-depth conversation as well as performance examples and tutorials. Projects for norns are primarily built and maintained by the lines community, so any questions/trouble with a specific project should be directed to its thread.

## clear a currently-running script {#clear-script}

Press K1 to toggle from PLAY to HOME. Highlight `SELECT` and hold K1 -- you'll see `CLEAR` in the middle of the screen. Press K3 to clear the currently running script.

## 'available' scripts do not appear in maiden {#available}

![](/docs/norns/image/help-images/blank_available.png)

If you are not seeing any scripts populate under maiden's [available](/docs/norns/maiden/#available) tab:

- confirm both norns and your other computer are connected to the same [wifi network](/docs/norns/wifi-files/#connect)
- confirm that you are on [the latest version](/docs/norns/wifi-files/#update) of the core norns software
- connect to maiden and confirm that the following files exist under `data/sources`: `base.json` and `community.json`
  - if they do not exist, or the files themselves are empty, import [fresh copies](https://github.com/monome/maiden/tree/main/sources) of each
- if the `data/catalogs` folder does not exist, create it
- restart your device

Following the steps above should create the necessary circumstances for the `community` and `base` catalogs to populate.

## error messages

### DUPLICATE ENGINES

Supercollider fails to load if you have multiple copies of the same class, which are commonly contained in duplicate `.sc` files inside of `dust` (the parent folder for the projects installed on norns).

To typically solve this, [connect](../play/#network-connect) via wifi and open [maiden](../maiden). Type `;restart` into the maiden _matron_ REPL at the bottom (the `>>` prompt).

This will restart the audio components and output their logs. If there's a duplicate class an error message like the following will be shown:

```
DUPLICATE ENGINES:
/home/we/dust/code/ack/lib/Engine_Ack.sc Engine_Ack.sc
/home/we/dust/code/we/lib/Engine_Ack.sc Engine_Ack.sc
### SCRIPT ERROR: DUPLICATE ENGINES
```

In this example, the `Engine_Ack.sc` engine is duplicated in two projects: `ack` and `we`. Using maiden, you would expand each project's `lib` folder to reveal the duplicated `Engine_Ack.sc`. After you remove one of the offending engines, execute `SYSTEM > RESTART` from the norns menu.

If the issue persists or maiden does not report duplicate engines, please email help@monome.org. Keep in mind that unless you're familiar with Supercollider, do not tamper with its internal folder structure. All typical norns functionality can be handled through the maiden project manager or the `dust` folder.

### LOAD FAIL

This simply means there is an error in the script you're trying to load.

Connect via wifi and open maiden to see the error message when you again try to load the script.

A common problem may be a missing engine. Check the output for something like:

```
### SCRIPT ERROR: missing Timber
```

In this example, the script requires `Timber`, so go find it in the Project Manager and install it. If you had just recently installed `Timber`, you need to restart your norns through SLEEP or entering `;restart` in the matron REPL.

### SUPERCOLLIDER FAIL

This indicates that something is wrong with SuperCollider, which could be due to various issues. First always just try rebooting via `SYSTEM > SLEEP`.

If you're able to load maiden, there are two tabs in the main REPL area (above the `>>` prompt at the bottom of your screen). The first tab is for `matron`, the control program that runs scripts -- the other is `sc` for SuperCollider. Click into the `sc` tab and type `;restart` into the REPL. That should show you what is going on inside of SuperCollider.

- You might have a [duplicate engine](#duplicate-engines).
- You might be [missing a required engine](#load-fail).
- If this doesn't help, you may need to re-flash your norns with a clean image (after backing up any of your data).
- If this doesn't fix it, there may be a hardware issue: e-mail help@monome.org.

### FILE NOT FOUND

If a newly-renamed script throws a `file not found` error in maiden, it is likely because the system has not registered the name change -- even though you see the new name in the UI. Perform a hard refresh on your browser ([how?](https://fabricdigital.co.nz/assets/How-to-hard-refresh-browser-infographic.jpg)).

### not an error: 'm.read: /home/we/dust/data/<script_name>/<script_name>.pmap not read.' {#not-an-error}

This is not an error. We're including it here because it often gets mistaken for one, as it can accompany other issues with a script load.

This message is only reporting that the script has never (successfully) been run before. It will go away once the norns system creates a default .pmap for that script, which happens the first time the script is cleanly exited.

## reboot via maiden

To perform a quick reboot of the entire norns stack (for instance, when installing a script with a synth engine), reboot SuperCollider *then* reboot matron.

To reboot matron, the Lua layer of norns, execute `;restart` in the `matron` tab of the maiden REPL.

To reboot SuperCollider, the synthesis layer of norns, execute `;restart` in the `supercollider` tab of the maiden REPL.