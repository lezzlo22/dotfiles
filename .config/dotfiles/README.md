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

## NVIDIA (GTX 1050 Ti) — driver & the decisions it forced

The GPU is Pascal, and a lot of config exists to work around NVIDIA on X11.

- **Driver = `nvidia-580xx-dkms` (580.178.04), not mainline `nvidia`.** The 590 driver
  series dropped Maxwell/Pascal/Volta, so a Pascal card like the 1050 Ti is stuck on
  the **580 legacy branch**, packaged in the AUR as `nvidia-580xx-*`. DKMS so the module
  rebuilds on each kernel bump (we run mainline `linux`). Companion: `nvidia-580xx-utils`
  + `lib32-nvidia-580xx-utils`, and `egl-gbm` / `egl-wayland` / `egl-x11`.

- **Picom backend = `glx` + `vsync = true`.** This is how screen tearing is handled on
  NVIDIA — we do *not* set `ForceFullCompositionPipeline` in an xorg.conf (the usual
  alternative). `blur-method = "none"` and effects are kept minimal; the 1050 Ti + legacy
  driver doesn't love heavy GLX compositing.
  - History: picom previously ran the **`xrender`** backend because kitty's GPU/OpenGL
    rendering fought picom's GLX backend and spiked GPU memory. Once the terminal moved
    off kitty (below), GLX became usable again and we switched back for better vsync.

- **Terminal = alacritty, kitty removed.** Two reasons stacked up:
  1. **fcitx5/Mozc input race** — the `$mod+Return` bind launches alacritty with
     `XMODIFIERS= GTK_IM_MODULE= QT_IM_MODULE=` unset to dodge a new-window input-loss
     race with fcitx5 (this is the reason annotated in the i3 config).
  2. **NVIDIA/kitty GPU-memory issue** — kitty's OpenGL rendering vs. picom-GLX spikes
     (the same clash noted above).
  kitty is no longer installed.

- **No explicit KMS modeset.** There's no `nvidia-drm.modeset=1` on the kernel cmdline and
  no `modprobe.d` drop-in — modesetting rides the driver default. (Note this if Wayland or
  early-KMS ever matters.)

## Key packages

| Role | Package | Role | Package |
|------|---------|------|---------|
| WM | `i3-wm` | Compositor | `picom` |
| Bar | `i3blocks`, `i3status` | Terminal | `alacritty` |
| Launcher | `rofi` | Notifications | `dunst` |
| Lock screen | `i3lock-color` | Idle daemon | `xidlehook` |
| Tray bridge | `snixembed` | Display config | `autorandr` |
| Theming | pywal (`wal`) | Input method | `fcitx5` + `fcitx5-mozc` |
| Key remap | `kanata` | Bluetooth | `blueman` |
| Wi-Fi | `iwd` | Login | `sddm` |
| X server | `xorg-server` | GPU driver | `nvidia-580xx-dkms` (+ `-utils`) |
