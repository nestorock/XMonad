# XMonad
XMonad Configuration (with Two Screens)

#### 1. System Information:

- **[** *Debian GNU/Linux 8.6 (jessie)* **]**
- **[** *XMonad 0.12* **]**
- **[** *XMobar 0.24.3* **]**

#### 2. XMonad Configuration:

    .  modkey: Windows Key
    . Screens: I use a keys combination (modkey+d) to toggle between one and two screens.
    .  xmobar: I have two differents xmobar panel for system information on the Top of the screens.
               And I have one xombar panel for Music (MPD) on the bottom of the principal screen.
               I use icons into xmobar panel
               
#### 3. XMobar Panels:

    .        .xmobarrc: Top panel used when I have only one screen.
    .   .xmobarrc_left: Top panel used for left screen.
    .  .xmobarrc_right: Top panel used for right screen.
    .  .xmobarrc_musci: Bottom panel used for music information (MPD).
    
#### 4. Scripts:

    .       DebianVersion.sh: Use Zenity info dialog to show Debian version.
    .       XMonadVersion.sh: Use Zenity info dialog to show XMonad and XMobar version.
    .           dmenuExit.sh: Use dmenu to show a options to exit from system.
    .          killXmobar.sh: Kill all xmobar process.
    .           getXmobar.sh: Used ONLY for Music panel. Change X coordinate depend on screens used.
                              (I wanted to use this script to select Top panel too, but I couldn't)
    .     recompileXMonad.sh: Kill all xmobar process, calling to killXmobar.sh script, recompile and
                              restart XMonad.
    . toggleDisplayXMonad.sh: Used to toggle between one and two screens.
    .             volumen.sh: Used to show system volume into Top xmobar panel.


                 


![Image of Yaktocat](https://github.com/nestorock/XMonad/blob/master/images/UnderConstruction.jpg)

