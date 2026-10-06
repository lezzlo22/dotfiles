# dotfiles

Config for my Arch + i3 (X11) setup, tracked with a **bare git repo** in `$HOME`.
Files live in place — no symlinks, no `stow`.

## System

- **OS:** Arch Linux, systemd-boot
- **WM:** i3 (X11), i3bar + i3blocks
- **GPU:** NVIDIA GTX 1050 Ti
- **Terminal:** kitty · **Launcher:** rofi · **Notifs:** dunst
- **Theming:** pywal (`~/.cache/wal`, generated — not tracked)
- **Login:** SDDM · **Wi-Fi:** iwd · **Bluetooth:** blueman

## Using the repo

```sh
# the alias (also added to ~/.bashrc)
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dotfiles status
dotfiles add ~/.config/foo/bar.conf   # track a new file
dotfiles commit -m "..."
dotfiles push
```

`status.showUntrackedFiles no` is set, so `$HOME`'s untracked junk stays hidden —
only explicitly added files show up.

### New machine

```sh
git clone --bare <remote-url> $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout        # may warn about existing files; back them up and retry
dotfiles config status.showUntrackedFiles no
```

## Gotchas / decisions (why things are the way they are)

- **Tray icons (snixembed):** i3bar's tray only speaks the old XEmbed protocol;
  modern AppImage apps (limusic, blueman) expose icons via StatusNotifier/AppIndicator.
  `snixembed --fork` bridges SNI → XEmbed. Must start *before* any tray app. In i3 config.

- **Idle/lock (xidlehook is the sole authority):** `xset s off -dpms` in i3 config
  disables X's built-in screensaver + DPMS, which ignore audio and would blank the
  monitor at 600s even during playback. xidlehook then owns idle: 600s → lock,
  1800s → hibernate, with `--not-when-audio --not-when-fullscreen`.

- **picom (xrender backend):** GLX backend conflicts with kitty's OpenGL on the
  NVIDIA 1050 Ti and spikes GPU memory. Keep `backend = "xrender"`.

- **SDDM XAUTHORITY:** SDDM sets `XAUTHORITY` to `/tmp/xauth_*`, not `~/.Xauthority`.
  Scripts must read `$XAUTHORITY`, never hardcode `~/.Xauthority`.
