if status is-interactive
    fastfetch
end

abbr vim nvim
abbr --add ls --position command 'eza --icons'

set -g fish_greeting
set -gx EDITOR nvim
set -gx GBM_BACKEND nvidia-drm
set -gx __GLX_VENDOR_LIBRARY_NAME nvidia
set -gx LIBVA_DRIVER_NAME nvidia
set -gx XDG_SESSION_TYPE wayland
set -gx ELECTRON_OZONE_PLATFORM_HINT auto
set -gx NVD_BACKEND direct

if [ (tty) = "/dev/tty1" ]
	exec dbus-run-session river
end

if test (tty) = "/dev/tty1"
	exec dbus-run-session river
end

# Created by `pipx` on 2026-04-16 15:22:09
set PATH $PATH /home/tai/.local/bin
