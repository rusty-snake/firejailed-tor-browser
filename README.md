# HOWTO: Firejailed Tor Browser #

Version: 0.0.0 (**WIP**)

  * Install [firejail](https://firejail.wordpress.com/) ([repo](https://github.com/netblue30/firejail)) 0.9.60-rc1 or newer.
  * Download the [Tor Browser](https://www.torproject.org/download/)  
    Recommendations:
    * english (en\_US)
    * linux
    * 64bit
    * not alpha
  * Verify the signatur as descripted [here](https://www.torproject.org/docs/verifying-signatures.html.en).
  * Execute the `install_FTB.sh` or do the following steps:
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
    ```sh
    $ wget -O - https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master/tor-browser.desktop | sed "s/USER/$USER/g" > $HOME/.local/share/applications/tor-browser.desktop
    ```
  * Now you can start the Tor Browser from your DesktopEnvironment

--------------------

MIT License

Copyright (c) 2019 rusty-snake (https://github.com/rusty-snake) <print_hello_world+License@protonmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
