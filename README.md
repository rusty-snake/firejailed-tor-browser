<table>
 <tr><td><h1>⚠️ Unmaintained Project</h1></td></tr>
</table>

# HOWTO: Firejailed Tor Browser

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) latest git, or if you are using a stable firejail release,
    have a look at [stable-profiles](stable-profiles).
  * Download [Tor Browser](https://www.torproject.org/download/)
  * Verify the signature as described [here](https://support.torproject.org/#how-to-verify-signature).
  * Execute the `install.sh` script in a terminal:
    ```bash
    $ ./install.sh ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
    ```
    Or do the following steps:
    * Create `${HOME}/.firejailed-tor-browser` and extract Tor Browser to it.
    * Copy the `firejailed-tor-browser.profile` file from this repo to `$HOME/.config/firejail/firejailed-tor-browser.profile`.
    * Copy the `firejailed-tor-browser.desktop.in` file from this repo to `$HOME/.local/share/applications/firejailed-tor-browser.desktop` and replace each occurrence of the string HOME with the content of `$HOME`.
    * Add `blacklist ${HOME}/.firejailed-tor-browser` to `$HOME/.config/firejail/disable-programs.local`
    * **Summary**
      ```bash
      $ mkdir $HOME/.firejailed-tor-browser
      $ tar -C "$HOME/.firejailed-tor-browser" --strip 1 -xJf ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
      $ wget -O "$HOME/.config/firejail/firejailed-tor-browser.profile" "https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/firejailed-tor-browser.profile"
      $ wget -O- "https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/firejailed-tor-browser.desktop.in" | sed "s;HOME;$HOME;g" > "$HOME/.local/share/applications/firejailed-tor-browser.desktop"
      $ echo 'blacklist ${HOME}/.firejailed-tor-browser' >> "${HOME}/.config/firejail/disbale-programs.local"
      ```
  * Now you can start Tor Browser from your Desktop Environment or by running `firejail --profile=firejailed-tor-browser "$HOME/Browser/start-tor-browser"`.
  * Additionally, you can restrict the available interfaces with the `net` command.
    * List all interfaces: `ip addr show` or `ifconfig`
    * Add the interface with your internet connection to `firejailed-tor-browser.local`
    * Example: `echo 'net wlan0' >> "${HOME}/.config/firejail/firejailed-tor-browser.local"`
  * Tor Browser 10.5 added Wayland support. firejailed-tor-browser.profile enables the use of the wayland backend and blocks access to X11.
    If you still rely on X11, you need to run `install.sh`/`update.sh` with `--x11` or add the following to your `firejailed-tor-browser.local`:
    ```
    include firejailed-tor-browser-x11.inc
    ```

--------------------

License: [MIT](LICENSE)
