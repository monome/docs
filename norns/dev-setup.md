---
layout: default
parent: scripting
grand_parent: norns
has_children: false
title: dev setup
nav_order: 3
has_toc: false
---

# norns dev setup

if using [maiden](../maiden) is plenty sufficient to create norns script, some experienced users may want to rely on development tools they are already familiar with.


## remote access via command line

### basics

when accessing norns via the command line (using [SSH / USB serial access](../advanced-access)), scripts can directly be edited this way using locally-installed editors (such an `nano` or `vi`).

this also allows interacting with [maiden from the command line](../maiden/#advanced-access)

this video is a walkthrough of this process:

<iframe width="560" height="315" src="https://www.youtube.com/embed/S-jhIT4mCcM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### sshfs - mount source files locally

`sshfs` allow to locally mount norns filesystem onto a development machine as if it were local. this allows you to use any prefered editor / tools installed locally.

```shell
mkdir /home/Documents/norns_mount
cd /home/Documents/norns_mount
shfs we@norns:/home/we/dust dust
```

please note that many editors provide an equivalent functionality.


### maiden-run - automatic reload

[`maiden-run`](https://github.com/ngwese/maiden-run) allows to automatically reload  a script when saving its source code.


## editor integration

### atom

this [comment](https://github.com/monome/norns/issues/1067#issuecomment-611732427) describes a working setup for using `atom` on a computer to access and code on a remote norns.


### emacs

to enable lua and supercollider support:

```elisp
;; lua

(use-package lua-mode
  :init
  (setq lua-indent-level 2))

;; sclang

(defvar my-supercollider-scel-path "~/.local/share/SuperCollider/Emacs/scel")

(let ((sclang-dir (concat my-supercollider-scel-path "/el")))
  (when (file-directory-p sclang-dir)
    (normal-top-level-add-to-load-path (list sclang-dir))))

(when (and (locate-library "sclang")
           (locate-library "sclang-vars"))
  (use-package sclang
    :ensure nil
    :demand))
```

Emacs can access norns filesystem as if local using [TRAMP](https://www.gnu.org/software/tramp/).

```shell
	M-x find-file
  /ssh:we@norns.local:/home/we/dust/
```

to prevent having to re-type the password each time, put this line in your `~/.authinfo`:

```conf
machine norns.local login we port ssh password sleep
```

for spawning a maiden repl, do it using either command:
 - `tramp-term` (built-in `term` + [tramp-term](https://github.com/randymorris/tramp-term.el))
 - `vterm-toggle-cd` ([vterm](https://github.com/akermu/emacs-libvterm) + [vterm-toggle](https://github.com/jixiuf/vterm-toggle))


### VSCode

norns can be accessed as if locally using [Remote - SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh).

additionally, [@midouest](https://norns.community/en/authors/midouest) made the [norns-repl vscode extension](https://llllllll.co/t/norns-repl-vscode-extension/41382) allowing to spawn and interact with a remote maiden repl.


### vim / neovim

[vim-norns](https://github.com/madskjeldgaard/vim-norns) provides various commands to spawn and interact with a maiden repl.

to enable support for supercollider syntax, use [scvim](https://github.com/supercollider/scvim) .


## supercollider

### installing extension classes (ugens...)

simply drop them into `/home/we/.local/share/SuperCollider/Extensions/`.

sub-folders are allowed.

see [the official supercollider doc](https://doc.sccode.org/Guides/UsingExtensions.html) for more info.


### norns engines on desktop

first, you'll need to copy both your engine code & [norns' supercollider sources](https://github.com/monome/norns/tree/main/sc/core) into your supercollider extensions folder (or any sub-folder). in scide, you can find the extensions path by running `Platform.userExtensionDir;`. recompile your class library & you should hear a familiar tone on boot.

using this strategy, you can use your engine `.sc` class code as-is and test out commands in a separate `.scd` file using `CroneTester`. first, set the engine - `CroneTester.engine('myengine');` - then send a command `CroneTester.cmd('mycommand', [array, of, arguments]);`. for midi-like code you can use a snippet like this:

```sclang

MIDIdef.noteOn(\keybOn, {
    arg vel, nn, chan, src;
    CroneTester.cmd('noteOn', [nn, nn.midicps, vel]);
})
MIDIdef.noteOff(\keybOff, {
	  arg vel, nn;
    CroneTester.cmd('noteOff', [nn]);
});
```

See also those [Mac OS specific instructions](https://gist.github.com/mimetaur/18346a71f1444ec8bea98a0c3c6fa365)


### controlling a computer's supercollider with norns

one can patch the value of `ext_addr` / `ext_port` in function `o_init` in `/home/we/norns/matron/src/oracle.c` to point to your computer IP.
