# HOWTO: Firejailed Tor Browser #

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) lastet git.
  * Download the [Tor Browser](https://www.torproject.org/download/)  
  * Verify the signatur as descripted [here](https://support.torproject.org/#how-to-verify-signature).
  * Execute `install.sh` in a terminal:
    ```bash
    $ ./install.sh ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
    ```
    Or do the following steps:
    * Create `${HOME}/.firejailed-tor-browser` and extract the tor-browser to it.
    ```bash
    mkdir ${HOME}/.firejailed-tor-browser
    tar -C "${HOME}/.firejailed-tor-browser" --strip 1 -xJf ~/Downloads/tor-browser-linux64-8.5.4_en-US.tar.xz
    ```
    * Copy the `firejailed-tor-browser.profile` file from this repo to `$HOME/.config/firejail/firejailed-tor-browser.profile`.
    * Copy the `firejailed-tor-browser.desktop` file from this repo to `$HOME/.local/share/applications/firejailed-tor-browser.desktop` and replace each occurrence of the string HOME with the content of `$HOME`. You can do this by running the following in a terminal:
    ```bash
    $ wget -O - https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/firejailed-tor-browser.desktop | sed "s,HOME,${HOME},g" > ${HOME}/.local/share/applications/firejailed-tor-browser.desktop
    ```
  * Now you can start the Tor Browser from your Desktop Environment or by running `firejail --profile=firejailed-tor-browser $HOME/.firejailed-tor-browser/Browser/start-tor-browser`.

--------------------

License: [MIT](LICENSE)
