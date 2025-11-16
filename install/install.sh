#1/bin/sh

echo "Installing Paru"

pacman --noconfirm -S paru

echo "\n\nInstalling Niri & Noctalia-shell"

paru --noconfirm -S niri noctalia-shell quickshell ttf-roboto inter-font gpu-screen-recorder brightnessctl ddcutil cliphist matugen-git cava wlsunset xdg-desktop-portal python3 polkit-kde-agent wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-gnome

echo "\n\nInstalling Tui Greeter"

paru --noconfirm -S tuigreet
systemctl enable greetd

cat <<EOT >>/etc/greetd/config.toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd /bin/niri-session"
user = "greeter"
EOT

echo "\n\nInstalling Flatpak and apps"

paru --noconfirm -S flatpak

flatpak install -y com.brave.Browser com.valvesoftware.Steam dev.vencord.Vesktop io.github.radiolamp.mangojuice com.spotify.Client com.vysp3r.ProtonPlus io.github.kolunmi.Bazaar org.freedesktop.Platform.VulkanLayer.MangoHud//25.08

echo "\n\nCopying wallpapers"

cp -r ./Wallpapers $HOME/Pictures/Wallpapers
