#!/bin/bash

# Set your install and download directory
INSTALL_DIR="/home/satyajit/App/chrome-lin"
DOWNLOAD_DIR="/tmp/chrome-lin64"
GITHUB_API_URL="https://api.github.com/repos/uazo/cromite/releases/latest"

# Function to download and install the latest version
update_cromite() {
    echo "Checking for new updates..."

    # Fetch the latest release details from GitHub API
    latest_release_info=$(curl -s $GITHUB_API_URL)

    # Extract the URL of the latest tarball (chrome-lin64.tar.gz) from the JSON response
    LATEST_TAR_URL=$(echo "$latest_release_info" | jq -r '.assets[] | select(.name=="chrome-lin64.tar.gz") | .browser_download_url')

    if [ -z "$LATEST_TAR_URL" ]; then
        echo "Failed to fetch the latest release URL. Continuing with the current version..."
        return
    fi

    # Check if the installed version exists by globbing the install directory
    # Assume the installed version is part of the filename in the $INSTALL_DIR
    INSTALLED_VERSION=$(find $INSTALL_DIR -maxdepth 1 -type f -name 'chrome*' -exec basename {} \; | head -n 1)

    if [ -z "$INSTALLED_VERSION" ]; then
        echo "No existing installation found, installing the latest version."
    else
        echo "Current installed version: $INSTALLED_VERSION"
    fi

    # Check if the current version matches the latest URL or not (simply checking URL here)
    if [ "$LATEST_TAR_URL" != "$RELEASE_URL" ]; then
        echo "New update found, downloading the latest release..."
        curl -L "$LATEST_TAR_URL" -o $DOWNLOAD_DIR.tar.gz
        echo "Extracting the new version..."
        tar -xvzf $DOWNLOAD_DIR.tar.gz -C $INSTALL_DIR --strip-components=1
        echo "Update complete!"
    else
        echo "Already up-to-date."
    fi
}

# Check if the system is online by pinging Cloudflare's DNS (1.1.1.1)
if ping -c 1 1.1.1.1 &> /dev/null; then
    update_cromite
else
    echo "System is offline, skipping update check."
fi

# Now launch the browser
echo "Launching Cromite..."
$INSTALL_DIR/chrome
