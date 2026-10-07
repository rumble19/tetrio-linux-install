#!/bin/bash

set -euo pipefail

app_name="tetrio"
literal_name_of_installation_directory=".tarball-installations"
universal_path_for_installation_directory="$HOME/$literal_name_of_installation_directory"
app_installation_directory="$universal_path_for_installation_directory/tetrio"
desktop_page="https://tetr.io/about/desktop/"
local_bin_path="$HOME/.local/bin"
local_application_path="$HOME/.local/share/applications"
app_bin_in_local_bin="$local_bin_path/$app_name"
desktop_in_local_applications="$local_application_path/$app_name.desktop"
icon_path="$app_installation_directory/icon.png"
executable_path="$app_installation_directory/TETR.IO"
installed_version_file="$app_installation_directory/.installed-version"

echo "Welcome to Tetr.io tarball installer, just chill and wait for the installation to complete!"

# The download page links to builds/<major>/..., so the newest major version can be
# read from it instead of being hardcoded. Set TETRIO_VERSION to pin a specific one.
tetrio_desktop_version="${TETRIO_VERSION:-}"
if [ -z "$tetrio_desktop_version" ]; then
  echo "Checking the latest desktop version"
  tetrio_desktop_version=$(curl -fsSL "$desktop_page" | grep -oE 'builds/[0-9]+/' | grep -oE '[0-9]+' | sort -n | tail -n 1 || true)
  if [ -z "$tetrio_desktop_version" ]; then
    echo "Could not detect the latest version from $desktop_page" >&2
    echo "Re-run with the version set manually, e.g. TETRIO_VERSION=10 ./install.sh" >&2
    exit 1
  fi
fi
echo "Desktop version: $tetrio_desktop_version"

official_package_location="${desktop_page}builds/$tetrio_desktop_version/TETR.IO%20Setup.tar.gz"

# Download and unpack into a temp directory first, so a failed download
# never leaves you without a working installation.
work_directory=$(mktemp -d)
trap 'rm -rf "$work_directory"' EXIT

echo "Downloading the package"
curl -fL -o "$work_directory/tetrio.tar.gz" "$official_package_location"

# The tarball has a single versioned top-level directory (tetrio-desktop-X.Y.Z),
# stripping it means we don't need to know its name.
mkdir "$work_directory/app"
tar -xf "$work_directory/tetrio.tar.gz" -C "$work_directory/app" --strip-components=1

if [ ! -f "$work_directory/app/TETR.IO" ]; then
  echo "The downloaded package does not look as expected (no TETR.IO executable), aborting" >&2
  exit 1
fi

echo "Downloaded and untarred successfully"

curl -fsSL -o "$work_directory/app/icon.png" https://txt.osk.sh/branding/tetrio-color.png || echo "Could not download the icon, continuing without it"
echo "$tetrio_desktop_version" > "$work_directory/app/.installed-version"

if [ -d "$app_installation_directory" ]; then
  if [ -f "$installed_version_file" ]; then
    echo "Replacing installed version $(cat "$installed_version_file")"
  else
    echo "Old app files are found, removing..."
  fi
  rm -rf "$app_installation_directory"
fi

mkdir -p "$universal_path_for_installation_directory" "$local_bin_path" "$local_application_path"
mv "$work_directory/app" "$app_installation_directory"

echo "$app_name successfully moved to your safe place!"

cat > "$app_bin_in_local_bin" <<EOF
#!/bin/bash
exec "$executable_path" "\$@"
EOF
chmod u+x "$app_bin_in_local_bin"

echo "Created executable for your \$PATH if you ever need"

cat > "$desktop_in_local_applications" <<EOF
[Desktop Entry]
Name=Tetr.IO
Comment=Stack those blocks!
Keywords=game;tetris;tetrio;
Exec="$executable_path"
Icon=$icon_path
Terminal=false
Type=Application
Categories=Game;
EOF

echo "Created desktop entry successfully"

echo "Installation is successful, have fun!"
