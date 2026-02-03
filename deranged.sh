

#!/bin/bash

#please ignore my schizophrenic sideprojects. thanks!
# ====================================================
# Build a “full Arch64 SNES ROM” skeleton with extra packages
# ====================================================
# WARNING: Only emulated fun. Real SNES cannot run Arch64.
# ====================================================

set -e

# --------- CONFIGURATION ---------
ARCH64_URL="https://fastly.mirror.pkgbuild.com/iso/2026.02.01/archlinux-bootstrap-2026.02.01-x86_64.tar.zst"
ROM_NAME="arch_snes64_full.rom"
WORKDIR="$(pwd)/arch_snes64_build"

# List of small packages to pre-install
PREPACKAGES=("bash" "coreutils" "neofetch" "htop" "nano" "tetris")

# --------- CLEAN PREVIOUS BUILD ---------
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR/rootfs" "$WORKDIR/assets" "$WORKDIR/qemu" "$WORKDIR/scripts" "$WORKDIR/packages"

# --------- DOWNLOAD & EXTRACT ARCH64 ---------
echo "[1/7] Downloading Arch64 bootstrap..."
wget -O "$WORKDIR/arch64.tar.zst" "$ARCH64_URL"

echo "[2/7] Extracting rootfs..."
tar --use-compress-program=unzstd -xf "$WORKDIR/arch64.tar.zst" --strip-components=1 -C "$WORKDIR/rootfs"

# --------- STRIP DOWN ROOTFS ---------
echo "[3/7] Stripping unnecessary files..."
rm -rf "$WORKDIR/rootfs/usr/share/man" \
       "$WORKDIR/rootfs/usr/share/doc" \
       "$WORKDIR/rootfs/usr/share/info" \
       "$WORKDIR/rootfs/var/cache/pacman/pkg"

# --------- DOWNLOAD PRE-INSTALL PACKAGES ---------
echo "[4/7] Preparing pre-installed packages..."
for pkg in "${PREPACKAGES[@]}"; do
    echo "Downloading $pkg..."
    # This is simplified: you can download .pkg.tar.zst manually for each package
    # and place them in WORKDIR/packages/
    touch "$WORKDIR/packages/$pkg.pkg.tar.zst"  # placeholder for demonstration
done
mkdir -p "$WORKDIR/rootfs/opt/packages"
cp "$WORKDIR/packages/"* "$WORKDIR/rootfs/opt/packages/"

# --------- ADD FAKE PACMAN SCRIPT ---------
echo "[5/7] Adding fake pacman script..."
cat > "$WORKDIR/scripts/fake_pacman.sh" << 'EOF'
#!/bin/bash
echo "Loading packages from ArchSNES64 repo..."
for pkg in "$@"; do
  echo "Installing $pkg... done!"
done
EOF
chmod +x "$WORKDIR/scripts/fake_pacman.sh"

# --------- ADD BOOT SCRIPT ---------
echo "[6/7] Adding boot script..."
cat > "$WORKDIR/scripts/boot.sh" << 'EOF'
#!/bin/bash
echo "Booting Arch64 SNES Emulator..."
echo "Loading kernel..."
sleep 1
echo "Starting bash shell..."
sleep 1
echo
echo "Welcome to Arch64 on SNES!"
PS1="arch-snes64$ "
export PATH=$PATH:./bin
# Pre-installed packages are in /opt/packages
bash --noprofile --norc
EOF
chmod +x "$WORKDIR/scripts/boot.sh"

# --------- ADD PLACEHOLDER ASSETS ---------
echo "[7/7] Adding splash and font placeholders..."
echo "SNES splash placeholder" > "$WORKDIR/assets/splash.txt"
echo "ASCII font placeholder" > "$WORKDIR/assets/terminal_font.chr"

# --------- PACKAGE EVERYTHING INTO A “ROM” ---------
echo "Packaging ROM..."
tar -czf "$ROM_NAME" -C "$WORKDIR" .
echo "Build complete! ROM file: $ROM_NAME"
echo
echo "Pre-installed packages are in /opt/packages."
echo "You can also use pacman on SD swap for real package installs."
