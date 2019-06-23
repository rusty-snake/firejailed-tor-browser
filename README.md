# HOWTO: Firejailed Tor Browser #

Version: 0.0.1

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) lastet git.
  * Download the [Tor Browser](https://www.torproject.org/download/)  
  * Verify the signatur as descripted [here](https://www.torproject.org/docs/verifying-signatures.html.en).
  * Execute the `install_FTB.sh` script in a terminal:
    ```bash
    $ ./install_FTB.sh ~/Downloads/tor-browser-linux64-8.5.1_en-US.tar.xz
    ```
    Or do the following steps:
    * Create a directory named `.tor-browser` in your HOME-directory.
    * Extract the TBB archive to `.tor-browser` with the following directory structure:
    ```
    $ tree -L 1 $HOME/.tor-browser
    /home/USERNAME/.tor-browser
    ├── Browser
    └── start-tor-browser.desktop
    ```
    * Copy the `tor-browser.profile` file from this repo to `$HOME/.config/firejail/tor-browser.profile`.
    * Copy the `tor-browser.desktop` file from this repo to `$HOME/.local/share/applications/tor-browser.desktop` and replace each occurrence of the string USER with your USERNAME. You can do this by running the following in a terminal:
    ```bash
    $ wget -O - https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/tor-browser.desktop | sed "s:HOME:${HOME}:g" > $HOME/.local/share/applications/tor-browser.desktop
    ```
  * Now you can start the Tor Browser from your DesktopEnvironment or by running `firejail --profile=tor-browser $HOME/.tor-browser/Browser/start-tor-browser`.

--------------------

License: [MIT](LICENSE)
