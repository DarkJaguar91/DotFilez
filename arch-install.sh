#!/bin/bash
#
# Arch Linux Post-Installation Setup Script
# This script handles initial package installations, including
# essential utilities, the AUR helper 'paru', a custom Wayland
# Desktop Environment (niri/noctalia-shell), and Flatpak applications.
#
# It MUST be run with 'sudo' (as root) for package installation.
#
#####################################################################
# Configuration and Variables
#####################################################################

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

LOG_FILE="/var/log/arch_installer_setup.log"
APP_ID="DarkJaguarOS-v0.1" # Identifier for unique file paths

#####################################################################
# Logging Helper Functions
#####################################################################

# Log an informational message
log_info() {
  local message="$1"
  echo -e "[INFO] $(date +'%Y-%m-%d %H:%M:%S') $message" | tee -a "$LOG_FILE"
}

# Log a success message
log_success() {
  local message="$1"
  echo -e "\033[32m[SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') $message\033[0m" | tee -a "$LOG_FILE"
}

# Log a failure message and exit
log_failure() {
  local message="$1"
  echo -e "\033[31m[FAILURE] $(date +'%Y-%m-%d %H:%M:%S') $message\033[0m" | tee -a "$LOG_FILE"
  exit 1
}

#####################################################################
# Core Functions
#####################################################################

# Function to check if the script is running as root (required for pacman)
check_root() {
  log_info "Verifying user privileges..."
  if [[ $EUID -ne 0 ]]; then
    log_failure "This script must be run as root (use 'sudo $0')."
  else
    log_success "Root privileges confirmed."
  fi
}

# Function to install essential packages using pacman
install_essentials() {
  log_info "Starting installation of core essential packages..."

  # The 'base-devel' group is required for building AUR packages (makepkg, gcc, etc.)
  # We also install the requested utilities and flatpak.
  local packages=(
    "base-devel"
    "git"
    "curl"
    "wget"
    "flatpak"
    "eza"
    "btop"
    "stow"
  )

  # Synchronize and update the package database
  log_info "Updating system package database..."
  if ! pacman -Sy --noconfirm; then
    log_failure "Failed to update package database. Check internet connection/mirror list."
  fi

  # Install packages
  log_info "Installing: ${packages[@]}..."
  # Use --needed to skip already installed packages and --noconfirm for automation
  if pacman -S "${packages[@]}" --noconfirm --needed; then
    log_success "Successfully installed essential packages: ${packages[@]}"
  else
    log_failure "Failed to install one or more essential packages. Aborting."
  fi
}

# Function to install the AUR helper 'paru'
install_paru() {
  log_info "Starting installation of the AUR helper 'paru'..."

  # Check if 'paru' is already installed
  if command -v paru &>/dev/null; then
    log_success "Paru is already installed. Skipping build process."
    return 0
  fi

  local temp_dir
  temp_dir=$(mktemp -d)
  local user_name # We need a regular user to run makepkg, NOT root

  # Find the first non-root user for building the package
  if [[ -n "${SUDO_USER:-}" ]]; then
    user_name="${SUDO_USER}"
    log_info "Using user '$user_name' for makepkg process."
  else
    log_failure "Could not determine the non-root user to build 'paru'. Run this script using 'sudo'."
  fi

  log_info "Cloning paru repository into $temp_dir..."
  # Use the non-root user to perform git operations
  if ! sudo -u "$user_name" git clone "https://aur.archlinux.org/paru.git" "$temp_dir/paru"; then
    log_failure "Failed to clone paru repository."
  fi

  # Change directory to the cloned repo
  pushd "$temp_dir/paru" >/dev/null || log_failure "Could not change directory to $temp_dir/paru."

  log_info "Building and installing paru using makepkg..."
  # Run makepkg as the non-root user. The -s (sync dependencies) and -i (install) flags are used.
  # The 'i' flag will prompt for root password if not run as root, but since we are running
  # this whole script as root, we use the '--noconfirm' flag for automation.
  if sudo -u "$user_name" makepkg -si --noconfirm; then
    log_success "Successfully installed 'paru' from AUR."
  else
    log_failure "Failed to build and install 'paru'. Check makepkg output in $LOG_FILE."
  fi

  # Clean up and return to the original directory
  popd >/dev/null
  rm -rf "$temp_dir"
  log_info "Cleaned up temporary directory $temp_dir."
}

# Function to install the niri Wayland compositor, noctalia-shell, and dependencies
install_desktop_environment() {
  log_info "Starting installation of niri, noctalia-shell, and required Wayland dependencies..."

  local user_name
  if [[ -n "${SUDO_USER:-}" ]]; then
    user_name="${SUDO_USER}"
  else
    log_failure "Cannot install desktop environment without knowing the non-root user. Run this script using 'sudo'."
  fi

  # 1. Install official packages (pacman)
  # xdg-desktop-portal is essential for applications to interact with the desktop environment
  # xdg-desktop-portal-wlr is the specific implementation for wlroots-based compositors like niri
  local official_packages=(
    "niri"
    "xwayland-satellite"
    "xdg-desktop-portal"
    "xdg-desktop-portal-gnome"
    "xdg-desktop-portal-gtk"
    "sddm"
  )

  log_info "Installing official Wayland/Display Manager packages: ${official_packages[@]}..."
  if ! pacman -S "${official_packages[@]}" --noconfirm --needed; then
    log_failure "Failed to install official desktop packages. Aborting."
  fi
  log_success "Successfully installed official desktop packages."

  # 2. Install AUR packages (paru)
  # niri, noctalia-shell, and matugen are typically found on the AUR
  local aur_packages=(
    "matugen"
    "wl-clipboard"
    "cliphist"
    "cava"
    "ddcutil"
    "qt6-multimedia-ffmpeg"
    "polkit-kde-agent"
    "noctalia-shell"
  )

  log_info "Installing AUR packages (niri, noctalia-shell) using paru as user '$user_name'..."
  # Paru should always be run by the non-root user.
  if ! sudo -u "$user_name" paru -S "${aur_packages[@]}" --noconfirm --needed; then
    log_failure "Failed to install one or more AUR packages via paru. Aborting."
  fi
  log_success "Successfully installed niri, noctalia-shell, and matugen."

  # 3. Enable the Display Manager (SDDM)
  echo -e "\n\033[33m--- Optional display manager for login ---\033[0m"
  read -r -p "Do you want to install SDDM login display manager (y/N)? " install_sddm

  if [[ "$install_sddm" =~ ^[Yy]$ ]]; then
    log_info "Enabling the Simple Desktop Display Manager (SDDM) service..."
    if systemctl enable sddm; then
      log_success "SDDM service enabled. It will start on next boot."
    else
      log_failure "Failed to enable SDDM service."
    fi
  fi
}

# Function to install Flatpak applications
install_flatpak_apps() {
  log_info "Starting installation of Flatpak applications..."

  local user_name
  if [[ -n "${SUDO_USER:-}" ]]; then
    user_name="${SUDO_USER}"
  else
    log_failure "Cannot install Flatpak apps without knowing the non-root user. Run this script using 'sudo'."
  fi

  # 1. Add Flathub repository (if not already added)
  log_info "Ensuring Flathub repository is added..."
  # Use --if-not-exists and run as the user. Installing system-wide is appropriate here.
  if ! sudo flatpak remote-add --if-not-exists flathub https://flathub.org/; then
    log_failure "Failed to add Flathub repository."
  fi
  log_success "Flathub repository is available."

  # 2. Define mandatory Flatpaks
  local mandatory_apps=(
    "io.github.kolunmi.Bazaar"
    "com.spotify.Client"
    "dev.vencord.Vesktop"
    "com.github.tchx84.Flatseal"
  )

  log_info "Installing mandatory Flatpak applications: ${mandatory_apps[@]}..."
  # Use 'sudo flatpak install' to install system-wide.
  if ! sudo flatpak install flathub "${mandatory_apps[@]}" --system --noninteractive --assumeyes; then
    log_failure "Failed to install one or more mandatory Flatpak applications."
  fi
  log_success "Successfully installed mandatory Flatpak applications."

  # 3. Prompt for gaming packages
  echo -e "\n\033[33m--- Optional Gaming Packages ---\033[0m"
  read -r -p "Do you want to install Steam, MangoHud, and ProtonPlus (y/N)? " install_gaming_apps

  if [[ "$install_gaming_apps" =~ ^[Yy]$ ]]; then
    local gaming_apps=(
      "com.valvesoftware.Steam"
      "org.freedesktop.Platform.VulkanLayer.MangoHud//25.08"
      "com.vysp3r.ProtonPlus"
    )

    log_info "Installing optional gaming Flatpak applications: ${gaming_apps[@]}..."
    if ! sudo flatpak install flathub "${gaming_apps[@]}" --system --noninteractive --assumeyes; then
      log_failure "Failed to install one or more optional gaming Flatpak applications."
    fi
    log_success "Successfully installed optional gaming Flatpak applications."

    # Install AUR package for Steam device support
    log_info "Installing AUR package 'steam-devices-git' for improved controller and device support..."
    local aur_gaming_package="steam-devices-git"
    if ! sudo -u "$user_name" paru -S "$aur_gaming_package" --noconfirm --needed; then
      log_failure "Failed to install AUR package '$aur_gaming_package' via paru. This may affect controller support."
    fi
    log_success "Successfully installed 'steam-devices-git' from AUR."

  else
    log_info "Skipping optional gaming Flatpak applications."
  fi
}

# Function to install the Fish shell, Fisher, and Tide theme
install_fish_shell() {
  log_info "Starting optional installation of Fish shell and accessories..."

  local user_name
  if [[ -n "${SUDO_USER:-}" ]]; then
    user_name="${SUDO_USER}"
  else
    log_failure "Cannot install Fish shell without knowing the non-root user. Run this script using 'sudo'."
  fi

  local user_home="/home/$user_name"

  echo -e "\n\033[33m--- Optional Shell Configuration ---\033[0m"
  read -r -p "Do you want to install Fish shell, Fisher, and the Tide theme (y/N)? " install_fish

  if [[ "$install_fish" =~ ^[Yy]$ ]]; then
    # 1. Install Fish shell via pacman
    log_info "Installing Fish shell via pacman..."
    if ! pacman -S fish fisher --noconfirm --needed; then
      log_failure "Failed to install fish shell."
    fi
    log_success "Fish shell installed."

    # 2. Install Tide theme using Fisher (must be run as the user)
    log_info "Installing Tide prompt theme using Fisher..."
    # Execute the fisher command directly with the fish executable as the non-root user
    if ! sudo -u "$user_name" fish -c "fisher install IlanFr/tide@v6"; then
      log_failure "Failed to install Tide theme."
    fi
    log_success "Tide theme installed."

    # 3. Set fish as default shell for the user
    log_info "Setting Fish as the default shell for user '$user_name'..."
    if ! chsh -s /usr/bin/fish "$user_name"; then
      log_info "Warning: Failed to set Fish as default shell for user $user_name. User may need to manually run 'chsh -s /usr/bin/fish' after reboot."
    else
      log_success "Fish set as default shell for user '$user_name'."
    fi

  else
    log_info "Skipping Fish shell installation."
  fi
}

setup_dotfiles() {
  log_info "Starting dotfiles setup using GNU Stow."

  local user_name
  if [[ -n "${SUDO_USER:-}" ]]; then
    user_name="${SUDO_USER}"
  else
    log_failure "Cannot set up dotfiles without knowing the non-root user."
  fi

  local user_home="/home/$user_name"
  # Get the absolute path to the directory containing this script.
  local script_dir
  # Use dirname and readlink to get the absolute path of the script's directory, essential when run via sudo
  script_dir=$(dirname "$(readlink -f "$0")")
  local dots_dir="$script_dir/dots" # Assuming 'dots' is a subdirectory of the script's location

  # 1. Check if the dots directory exists
  if [[ ! -d "$dots_dir" ]]; then
    log_failure "Dotfiles directory not found at: $dots_dir. Aborting dotfiles setup. Please ensure the 'dots' folder is in the same directory as this script."
  fi
  log_success "Found dotfiles repository at: $dots_dir."

  # 2. Dynamically discover the expected package names (subdirectories inside 'dots')
  log_info "Discovering dotfile packages inside $dots_dir..."
  local packages_to_stow=()
  # Iterate over all direct subdirectories in the dots folder
  for dir in "$dots_dir"/*/; do
    if [ -d "$dir" ]; then
      pkg_name=$(basename "$dir")
      packages_to_stow+=("$pkg_name")
    fi
  done

  if [ ${#packages_to_stow[@]} -eq 0 ]; then
    log_failure "No dotfile packages (subdirectories) found inside the 'dots' folder. Aborting stow."
  fi
  log_success "Discovered packages: ${packages_to_stow[*]}"

  log_info "Checking for existing config files in $user_home and backing them up..."

  # We check the final destination where stow creates the link, typically ~/.config/<pkg>
  local pkg # This is the package name (e.g., 'niri', 'fish')
  for pkg in "${packages_to_stow[@]}"; do
    # Check for existence at the common dotfiles configuration location: ~/.config/<pkg>
    local full_path="$user_home/.config/$pkg"

    # Check for the existence of the final target path (directory, file, or existing symlink)
    if [[ -d "$full_path" || -f "$full_path" || -L "$full_path" ]]; then
      local backup_path="${full_path}-bak-$(date +%Y%m%d%H%M%S)"
      log_info "Existing config/link found: $full_path. Moving to $backup_path."
      if ! sudo -u "$user_name" mv "$full_path" "$backup_path"; then
        log_failure "Failed to move existing config $full_path to backup."
      fi
    fi
  done
  log_success "Existing configuration files backed up successfully (if any)."

  # 3. Execute stow to create symlinks
  log_info "Running stow for packages: ${packages_to_stow[*]}"

  # Run stow as the non-root user. The target directory is the user's home folder ($user_home).
  if ! sudo -u "$user_name" stow dots; then
    log_failure "Failed to execute stow for dotfiles packages. Check dotfile structure and permissions."
  fi

  log_success "Dotfiles symlinked successfully using stow."
}

#####################################################################
# Main Execution
#####################################################################

main() {
  # Check privileges first
  check_root

  log_info "Arch installer script starting for App ID: $APP_ID"
  log_info "All output is logged to: $LOG_FILE"

  # 1. Install required core packages
  install_essentials

  # 2. Install PARU from AUR
  install_paru

  # 3. Install Desktop Environment components
  install_desktop_environment

  # 4. Install Flatpak applications and prompt for optional gaming apps
  # Must run after 'flatpak' is installed.
  install_flatpak_apps

  # 5. install fish if the user wants it
  install_fish_shell

  # 6. stow dots
  setup_dotfiles

  log_info "--- Initial Setup Complete ---"
}

# Run the main function
main
