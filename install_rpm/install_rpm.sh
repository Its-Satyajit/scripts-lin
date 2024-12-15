#!/bin/bash

# Display usage instructions
usage() {
    echo "Usage: $0 <url-to-rpm-file> [--ignore-signature]"
    exit 1
}

# Download the RPM file with retries using wget
download_rpm() {
    RPM_FILE=$(basename "$RPM_URL")

    if [[ -f "$RPM_FILE" ]]; then
        if rpm --quiet --checksig ./"$RPM_FILE"; then
            echo "$RPM_FILE is valid. No need to download again."
            return 0
        else
            echo "$RPM_FILE is corrupted. Removing it..."
            rm -f "$RPM_FILE"
        fi
    fi

    for attempt in {1..3}; do
        echo "Downloading $RPM_FILE from $RPM_URL using wget..."
        if wget -O "$RPM_FILE" "$RPM_URL"; then
            return 0
        fi
        echo "Download failed. Attempt $attempt of 3..."
        sleep 2
    done

    echo "Error downloading $RPM_URL after 3 attempts."
    exit 1
}

# Install the RPM file using zypper
install_rpm() {
    echo "Installing $RPM_FILE using zypper..."
    if [ "$IGNORE_SIGNATURE" == "true" ]; then
        sudo zypper install --no-gpg-checks ./"$RPM_FILE" | tee -a install_log.txt
    else
        sudo zypper install ./"$RPM_FILE" | tee -a install_log.txt
    fi
}

# Cleanup function to remove the RPM file
cleanup() {
    echo "Cleaning up..."
    rm -f "$RPM_FILE"
}

# Main script execution
if [ "$#" -lt 1 ]; then
    usage
fi

IGNORE_SIGNATURE="false"
[ "$2" == "--ignore-signature" ] && IGNORE_SIGNATURE="true"

RPM_URL=$1

# Log output to a file
exec > >(tee -i install_log.txt)
exec 2>&1

# Download and install the RPM file
download_rpm
if ! rpm --quiet --checksig ./"$(basename "$RPM_URL")"; then
    echo "Signature verification failed for $RPM_FILE."
    if [ "$IGNORE_SIGNATURE" == "true" ]; then
        echo "Ignoring signature and installing..."
        install_rpm
    else
        echo "Aborting installation."
        exit 1
    fi
else
    install_rpm
fi

# Cleanup after installation
cleanup

echo "Installation of $RPM_FILE completed successfully!"
