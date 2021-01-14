---
layout: default
parent: norns
has_children: false
title: maiden
nav_order: 3
has_toc: false
---

# maiden

sections: [project manager](#project-manager) &mdash; [repl](#repl) &mdash; [file viewer](#file-viewer) &mdash; [advanced access](#advanced-access)

_maiden_ is a browser-based portal for norns. It can be accessed via a norns-hosted hotspot, or if norns and your browser are on the same WIFI network.

To dive in, point your web browser at `norns.local` to see the maiden interface. If the site is not found, try connecting directly to the IP address shown on the norns screen, for example: `192.168.0.100`.

![](image/maiden-1.1.0.png)

The interface includes a meta-navigator in the far-left sidebar, which from bottom-to-top allows you to:

- access the [*project manager*](#project-manager), where you can manage, discover, and install community scripts on your norns
- toggle the [*repl*](#repl) (read-eval-print-loop), where your scripts + the system both print useful information
- toggle the [*file viewer*](#file-viewer), where you can view and select scripts to edit

Let's start with the *project manager*, so we can download some new community scripts!

## project manager

maiden features a project manager to help you discover and download new projects. Projects contain both engines and scripts.

You can access both the *base* (projects from monome) and *community* (projects from other artists) repositories via the books icon in the left-sidebar.

### installed

This tab shows which projects are currently installed on your norns.

![](image/maiden-installed.png)

Each entry has two actions: **update** and **remove**.

If you choose to update a project which you downloaded through maiden, please note that local modifications you have made will be overwritten. If you wish to retain multiple versions of a project, please reference the [SFTP](../sftp/) guide.

Once you update a project through the PROJECT MANAGER, you'll see a commit number listed on the right of the project's tile (like *34d225b*). Click a project's commit number to be brought to the project's GitHub page, where you can learn more about the project and verify that the version you have is the latest.

*nb. If you are updating a project through the PROJECT MANAGER that was not installed by using the PROJECT MANAGER, you will receive an error that the project cannot be found in the catalog. Please delete the previously installed version and reinstall through PROJECT MANAGER, which establishes the necessary git files for future updates.*

### available

This tab shows which projects are available through the *base* and *community* repositories.

Whenever maiden is loaded, it automatically refreshes both catalogs. If a script is released after you've loaded maiden, just press the `refresh all` button at the top of the page and all new entries will be added.![](image/maiden-available.png)

Many projects will have informational tags like **crow**, **drum**, **looper**, as well as a project description. Please note that the **lib** tag is specifically used to indicate that a project includes both a script *and* an engine, which will require a device restart.

Each entry has an **INSTALL** action, which can be used to install the selected script.

### contribute

To add to the [community project repo](https://github.com/monome/norns-community/blob/master/community.json), please submit a pull request with the following information:

```json
    {
      "project_name": "NAME",
      "project_url": "URL",
      "author": "NAME",
      "description": "WORDS",
      "discussion_url": "LINES_LINK",
      "tags": ["TAG", "TAG", "TAG"],
      "origin": "IF_APPLICABLE: lines"
    },
```

Be sure you include information at the top of your script to help future users:

```lua
-- scriptname: short script description
-- v1.0.0 @author
-- llllllll.co/t/22222
```

That last line is a link back to the thread number. There's a chicken-egg situation with starting a thread and uploading the project, so you may want to edit and upload your project just after creating a thread.

### gather

While many projects are held in the community repository, it can be hard to engage with a project's creator through GitHub. To facilitate discussion, many projects are also shared through the [norns Library on lines](https://llllllll.co/c/library).

The norns ecosystem was created with community as a focus. The exchange of ideas leads to new ideas. After you share your own script in the community repository, please create a new thread in the Library.

### fork

As you work with norns, you might change community scripts to integrate them into your particular toolkit. Perhaps you need to output specific ranges of MIDI messages, or maybe you're only using Just Intonation these days.

If you wish to share your modifications with the larger community, or if you feel your changes represent a new vision, please review our [living document of forking etiquette guidelines](https://llllllll.co/t/library-forking-etiquette-sharing-modifications/).

## repl

Messages are printed in the bottom panel. There are two tabs: matron is the main lua environment, and sc is supercollider which is the engine environment.

You can use the bottom prompt to type commands which will be interpreted by the system. For example:

```lua
print("hello there")
```

will display the expected message in the window above.

The clear icon to the right will clear the current messages.

If you need to restart the matron/crone environment for any reason (ie, the menu system is not accessible), you can issue a command via the REPL:

```
;restart
```

This will disconnect maiden, but once matron has restarted you can reconnect.

### fetch

Sometimes, scripts don't make it into the community repo. To fetch a script that's only hosted on a developer's GitHub:

- copy the URL of the lone project (eg. `https://github.com/tehn/test-update`)
- in maiden's repl, enter:

```lua
;install https://github.com/tehn/test-update
```

If the fetch was successful, you'll see:

```lua
starting...
installed "test-update"!
```

*nb. you may need to SYSTEM > RESET if the new project contains an engine*

If the fetch was unsuccessful, the cause is that a script is already installed with the same name. You'll see:

```lua
starting...
install failed: project test-update already exists in /home/we/dust/code
```

In which case, you just need to remove the redundant script and re-fetch.

## file viewer

The bulk of the *file viewer* is dedicated to the EDITOR, where you can view and edit the code of a selected script.

This panel lets you select the text you're editing in EDITOR.

There are top bar icons for various actions: **New**, **Delete**, **Duplicate**, **New Folder**, and **Rename**.

The `>`'s can be expanded to reveal a file tree. When you select a file, it will show in the EDITOR:

![](image/maiden-carrot.png)

### editor

This is where you can edit the selected script.

To the right there is a bar with three icons: disk is **SAVE**, **PLAY** will run the current script, **STOP** will stop and clear the currently running script.

These actions are bound to the following keyboard shortcuts:

- CMD/CTRL-`S` : save

- CMD/CTRL-`P` : play

- CMD/CTRL-`.` : stop

The editor can be configured for various modes (default, vim, emacs) in addition to tab size and light/dark mode. Click the gear icon at the bottom left of the screen. For more about maiden's keybindings, [see the docs in the maiden repository](https://github.com/monome/maiden/blob/main/docs/keybindings.md).

### programming reference

The bottom left ? icon can be used to navigate to the onboard programming reference.

You can manually open the API reference at `norns.local/doc`.

Also see the [scripting reference](../reference/).

## advanced access

### terminal REPL

To access maiden's REPL from a terminal session, SSH or screen into norns and execute:

```lua
maiden repl
```

### Command Line Interface

Nearly all of the project management operations exposed in the maiden web UI can be accomplished on the Command Line Interface (CLI).

To access:

```bash
ssh we@norns.local
...
maiden/maiden
web editor for norns scripts

Usage:
  maiden [command]

Available Commands:
  catalog     manage the script catalog
  help        Help about any command
  project     manage dust projects
  repl        matron/crone repl
  server      run the backend server for maiden
  version     print maiden version

Flags:
      --config string   use specific config file
      --debug           enable debug logging
  -h, --help            help for maiden

Use "maiden [command] --help" for more information about a command.
```

The maiden backend server also has sub-commands:

```bash
ssh we@norns.local
...

#
# the catalog sub-command is useful for updating the "we" and "community"
#
~/maiden/maiden catalog help
manage the script catalog

Usage:
  maiden catalog [command]

Available Commands:
  init        init an empty catalog file
  list        list projects
  update      update configured catalogs

Flags:
  -h, --help   help for catalog

Global Flags:
      --config string   use specific config file
      --debug           enable debug logging

Use "maiden catalog [command] --help" for more information about a command.
```

```bash
#
# the project sub-command is installing and updating project directories
#
~/maiden/maiden project help
manage dust projects

Usage:
  maiden project [command]

Available Commands:
  install     install a script/project
  list        list installed script/project(s)
  push        push a git based project
  remove      remove a project dir
  update      update a script/project

Flags:
  -h, --help   help for project

Global Flags:
      --config string   use specific config file
      --debug           enable debug logging

Use "maiden project [command] --help" for more information about a command.Have further usage questions? Visit the [norns: maiden](https://llllllll.co/t/norns-maiden/14052) topic on lines.
```
