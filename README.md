# HOWTO: Firejailed Tor Browser

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) lastet git or, if you are using a stable firejail release,
    have a look at [stable-profiles](stable-profiles).
  * Download the [Tor Browser](https://www.torproject.org/download/)  
  * Verify the signatur as descripted [here](https://support.torproject.org/#how-to-verify-signature).
  * Execute the `install.sh` script in a terminal:
    ```bash
    $ ./install.sh ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
    ```
    Or do the following steps:
    * Create `${HOME}/.firejailed-tor-browser` and extract the tor-browser to it.
    * Copy the `firejailed-tor-browser.profile` file from this repo to `$HOME/.config/firejail/firejailed-tor-browser.profile`.
    * Copy the `firejailed-tor-browser.desktop` file from this repo to `$HOME/.local/share/applications/firejailed-tor-browser.desktop` and replace each occurrence of the string HOME with the content of `$HOME`.
    * Add `blacklist ${HOME}/.firejailed-tor-browser` to `$HOME/.config/firejail/disable-programs.inc`
    * **Summary**
      ```bash
      $ mkdir $HOME/.firejailed-tor-browser
      $ tar -C "$HOME/.firejailed-tor-browser" --strip 1 -xJf ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
      $ wget -O "$HOME/.config/firejail/firejailed-tor-browser.profile" "https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/firejailed-tor-browser.profile"
      $ wget -O - "https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/firejailed-tor-browser.desktop" | sed "s;HOME;${HOME};g" > "$HOME/.local/share/applications/firejailed-tor-browser.desktop"
      $ echo 'blacklist ${HOME}/.firejailed-tor-browser' >> "${HOME}/.config/firejail/disbale-programs.local"
      ```
  * Now you can start the Tor Browser from your Desktop Environment or by running `firejail --profile=firejailed-tor-browser "$HOME/Browser/start-tor-browser"`.
  * Additional you can restrict the aviable interfaces with the `net` command.
    * List all interfaces: `ip addr show` or `ifconfig`
    * Add the interface with your internet connection to `firejailed-tor-browser.local`
    * Example: `echo 'net wlan0' >> "${HOME}/.config/firejail/firejailed-tor-browser.local"`

--------------------

License: [MIT](LICENSE)
