# Map Mouse Wheel Scroll to Arrow Keys in Terminal

This script allows you to map **mouse wheel scroll** actions to **Arrow Up** and **Arrow Down** keys in your terminal, enhancing productivity by enabling smooth navigation through terminal history and outputs using the mouse.

## Key Features
- **Map mouse wheel scroll** to **Arrow Up** and **Arrow Down** keys.
- **Easy terminal navigation** for scrolling command history or outputs.
- Compatible with **most Linux distributions** including **Debian-based (Ubuntu, Mint, etc.)**, **Red Hat-based (Fedora, CentOS, etc.)**, and **openSUSE**.

## Installation Guide for Most Linux Distributions

### Step 1: Install Required Tools

You will need two utilities: **`xdotool`** and **`xev`**. These tools allow you to simulate key presses and capture mouse events.

#### For Debian/Ubuntu-based Distributions:
Open a terminal and run the following command to install the necessary tools:

```bash
sudo apt update
sudo apt install xdotool x11-utils
```

#### For Fedora/CentOS/RHEL-based Distributions:
Use the following command:

```bash
sudo dnf install xdotool xorg-x11-utils
```

#### For openSUSE-based Distributions:
Use the following command:

```bash
sudo zypper install xdotool x11-utils
```

### Step 2: Create the Script

1. **Create the script file** in your home directory:

   ```bash
   nano ~/mouse_scroll_to_arrow.sh
   ```

2. **Add the following code** to the script file:

   ```bash
   #!/bin/bash

   while true; do
       # Capture mouse wheel events: button 4 (scroll up), button 5 (scroll down)
       EVENT=$(xev -root -event mouse | grep -E 'button (4|5)' | tail -n 1)
       
       if [[ $EVENT =~ "button 4" ]]; then
           # Simulate Arrow Up (scroll up)
           xdotool key Up
       elif [[ $EVENT =~ "button 5" ]]; then
           # Simulate Arrow Down (scroll down)
           xdotool key Down
       fi
       
       sleep 0.1
   done
   ```

### Step 3: Make the Script Executable

To make the script executable, run the following command:

```bash
chmod +x ~/mouse_scroll_to_arrow.sh
```

### Step 4: Run the Script

Now, you can run the script in the background to map mouse wheel actions to Arrow Up and Arrow Down keys.

```bash
~/mouse_scroll_to_arrow.sh &
```

The script will continue running in the background, listening for mouse scroll events and simulating the corresponding arrow key presses.

## Optional: Auto-Start the Script on Login

If you want the script to run automatically when you log into your system, follow these steps:

1. Open your **`~/.bashrc`** or **`~/.zshrc`** file (depending on your shell):

   ```bash
   nano ~/.bashrc  # For bash users
   ```

   or

   ```bash
   nano ~/.zshrc   # For zsh users
   ```

2. Add the following line to the end of the file to run the script at startup:

   ```bash
   ~/mouse_scroll_to_arrow.sh &
   ```

3. Save the file and exit the editor.

4. Reload your shell configuration:

   ```bash
   source ~/.bashrc  # For bash users
   ```

   or

   ```bash
   source ~/.zshrc   # For zsh users
   ```

The script will now start automatically when you open a new terminal session.

## Conclusion

By following this guide, you will map your **mouse scroll wheel** to simulate **Arrow Up** and **Arrow Down** keys in the terminal, making it easier to navigate through command history and terminal output. This simple script enhances terminal workflow on **most Linux distributions**, including **Debian-based**, **Red Hat-based**, and **openSUSE**.

---

### Troubleshooting

- **Mouse scroll not working?** Ensure that **`xev`** is detecting the scroll events. Use the `xev` command directly to verify that the mouse wheel events (button 4 for up, button 5 for down) are being captured.
- **Script not detecting scroll?** Confirm that the terminal is running with the proper environment, and check the event output from `xev`.

This approach offers a powerful way to integrate mouse wheel actions into terminal usage, saving time and boosting productivity across various Linux systems.