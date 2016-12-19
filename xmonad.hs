{-# LANGUAGE NoMonomorphismRestriction #-}
-- --------------------------
-- Conficuracion de XMonad --
-- --------------------------


-- Importamos librerias que se utilzaran.

-- Import Stuff.
import           XMonad
import           Data.Monoid
import           System.IO
import           System.Exit
import qualified Data.Map        as M
import qualified XMonad.StackSet as W

-- Utils
import           XMonad.Util.Loggers
import           XMonad.Util.NamedWindows
--import           XMonad.Util.Run(spawnPipe)
--import           XMonad.Util.Run(safeSpawn)
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

-- Hooks
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.UrgencyHook

-- Layouts
import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.Magnifier
import           XMonad.Layout.Monitor
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.ResizableTile
import qualified XMonad.Layout.IndependentScreens as LIS

-- Actions
import           XMonad.Actions.UpdatePointer

-- My Libraries
--import           RockXMobar

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myRockTerminal :: String
myRockTerminal = "urxvtc"

-- Whether focus follows the mouse pointer.
myRockFocusFollowsMouse :: Bool
myRockFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myRockClickJustFocuses :: Bool
myRockClickJustFocuses = False

-- Width of the window border in pixels.
--
myRockBorderWidth :: Dimension
myRockBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myRockModMask :: KeyMask
myRockModMask = mod4Mask

-- Border colors for unfocused and focused windows, respectively.
--
myRockNormalBorderColor :: String
myRockNormalBorderColor  = "grey"

myRockFocusedBorderColor :: String
myRockFocusedBorderColor = "cyan"

-----------------------------------------------------
-- Path config.
myRockHome       :: String
myRockHome       = "/home/nestorock/"

myRockMonadHome  :: String
myRockMonadHome  = myRockHome      ++ ".xmonad/"

myRockXMobar     :: String
myRockXMobar     = myRockMonadHome ++ "xmobar/"

myRockScripts    :: String
myRockScripts    = myRockMonadHome ++ "scripts/"

myRockIcons      :: String
myRockIcons      = myRockMonadHome ++ "icons/"

myRockLog        :: String
myRockLog        = myRockMonadHome ++ "log/"
--
-----------------------------------------------------

-----------------------------------------------------
-- Scripts config.
--  . getRockXmobar: Get the right config for XMobar.
getRockXmobar    :: String
getRockXmobar    = myRockScripts ++ "getXMobar.sh"

myRockXmobar     :: String
myRockXmobar     = "xmobar"

myRockScreenOne  :: String
myRockScreenOne  = " -x 0 "

myRockScreenTwo  :: String
myRockScreenTwo  = " -x 1 "

myRockCfgXmobar  :: String
myRockCfgXmobar  = myRockHome ++ ".xmobarrc"

myRockPanel      :: String
myRockPanel      = myRockXmobar ++ myRockScreenOne ++ myRockCfgXmobar


-----------------------------------------------------------------
-- Functions.
recompileXMonad = do
    spawn "/home/nestorock/.xmonad/scripts/recompileXMonad.sh"


-- Functions to change Screen mode.
toggledisplay = do 
  {  
    myRockScreenCount <- LIS.countScreens
    ;spawn ( xmobarTest myRockScreenCount )
--    ; if myRockScreenCount > 1
--         then do
--            spawn "xrandr --output HDMI1 --primary --mode 1920x1200; xrandr --output DP1 --off"
--         else do
--            spawn "xrandr --output HDMI1 --primary --mode 1920x1200 --right-of DP1 --output DP1 --mode 1280x1024"
--    ;spawn "/home/nestorock/.xmonad/scripts/killXmobar.sh"
--    ;setBG    
--    ;spawn "sleep 2; xmonad --restart"
  }

setBG = do 
  {
    spawn "sleep 0.5;feh --bg-scale '/home/nestorock/Pictures/tigre-de-ojos-azules.jpg'"    
  }

xmobarTest :: ScreenId -> String
xmobarTest (S s) = unwords["/home/nestorock/.xmonad/scripts/toggleDisplayXMonad.sh", show s]

xmobarPanel :: String -> Int -> String
xmobarPanel cfg s = unwords[getRockXmobar, cfg, show s]

--xmobarMusicConfig ns cfg = if ns > 1 then unwords[".xmobarrc"] else ".xmobarrc"
xmobarMusicPanel :: ScreenId -> String
xmobarMusicPanel (S s) = xmobarPanel "MUSIC" s

xmobarXConfig :: ScreenId -> Int -> String
xmobarXConfig ns s = if ns > 1 then unwords[myRockXMobar ++ ".xmobarrc" ++ show s] else myRockXMobar ++ ".xmobarrc"

--xmobarCommandPanel ns (S s) = xmobarPanel "TOP" s
xmobarCommandPanel :: ScreenId -> ScreenId -> String
xmobarCommandPanel ns (S s) = unwords ["xmobar", "-x", show s, xmobarXConfig ns s]


myRockStartupHook :: X ()
myRockStartupHook = do
  { 
    nScreens <- LIS.countScreens
    ;setBG
    ;spawnOnce "urxvtc"
--    >> spawn "xmobar .xmobarrc2"
--    >> spawn "~/getXMobar.sh > ~/.xmonad/log/getXMobar.log"
--    >> spawn ("xmessage " ++ (xmobarMusicPanel nScreens "MUSIC"))
    >> spawn ( xmobarMusicPanel nScreens )
--    >> spawn "/home/nestorock/.xmonad/scripts/getXMobar.sh 2 MUSIC"
  }

myMonitor :: Monitor a
myMonitor = monitor
  { 
      prop = ClassName "XClock"


    , rect = Rectangle (1920-200) (1200-200) 200 200
    , persistent = True
    , visible = True
--    , opacity = 0.6
    , name  = "clock"
  }
  

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

myRockManageHook :: ManageHook
myRockManageHook = (composeAll . concat $
   [  [ manageDocks                                                                   ]
    , [ className   =? c                 --> doShift "2:Web"      | c <- myWebs       ]
    , [ className   =? c                 --> doShift "3:Editors"  | c <- myEditors    ]
    , [ className   =? c                 --> doShift "4:Music"    | c <- myMusic      ]
    , [ className   =? c                 --> doShift "5:Gimp"     | c <- myGimp       ]
    , [ className   =? c                 --> doShift "6:Download" | c <- myDownLoad   ]
    , [ className   =? c                 --> doShift "7:Video"    | c <- myVideo      ]
    , [ className   =? c                 --> doShift "8:Documents"| c <- myDocuments  ]
    , [ className   =? c                 --> doCenterFloat        | c <- myFloats     ]
    , [ resource    =? c                 --> doCenterFloat        | c <- myFloats     ]
    , [ resource    =? c                 --> doIgnore             | c <- myResources  ]
    , [ manageHook def                                                                ]
   ]) where
   myChat      = ["turpial"]
   myDocuments = ["qpdfview", "libreoffice-startcenter"]
   myDownLoad  = ["Amule", "Transmission-gtk"]
   myEditors   = ["Sublime_text"]
   myFiles     = ["Thunar"]
   myFloats    = ["GParted", "VirtualBox", "XFontSel", "Xmessage", "alsamixer", "Zenity"]
   myGimp      = ["Gimp"]
   myMusic     = ["music"]
   myResources = ["desktop_windows", "kdesktop"]
   myVideo     = ["Openshot"]
   myWebs      = ["Iceweasel", "Firefox", "Midori"]



------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

-- default tiling algorithm partitions the screen into two panes
myRockLayout =   ModifiedLayout myMonitor $ mirrorLayout ||| columnLayout ||| fullscreenLayout
  where
     mirrorLayout     = named "mirror"     $ avoidStruts $ Mirror basicLayout
     columnLayout     = named "column"     $ avoidStruts $ basicLayout
     fullscreenLayout = named "fullscreen" $ avoidStruts $ noBorders Full
     basicLayout      = spacing 3 $ ResizableTall nmaster delta ratio []
       where
          nmaster = 1      -- The default number of windows in the master pane
          ratio   = 2/3    -- Default proportion of screen occupied by master pane
          delta   = 3/100  -- Percent of screen to increment by when resizing panes


myRockLayoutPrinter :: String -> String
myRockLayoutPrinter "mirror"     = wrap "<icon=" "/>" (myRockIcons ++ "tilebottom_trans.xpm")
myRockLayoutPrinter "column"     = wrap "<icon=" "/>" (myRockIcons ++  "tile_trans.xpm")
myRockLayoutPrinter "fullscreen" = wrap "<icon=" "/>" (myRockIcons ++  "fullscreen_trans.xpm")
myRockLayoutPrinter x            = x


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myRockEventHook = mempty
myRockEventHook :: Event -> X All
myRockEventHook = handleEventHook def <+> docksEventHook


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myRockLogHook :: [Handle] -> ScreenId -> X ()
myRockLogHook hs ns = mapM_ dynamicLogWithPP $ zipWith myRockPP hs [0..ns-1]
--myRockLogHook xmproc = do 
--  { 
--     dynamicLogWithPP  myRockPP { ppOutput = hPutStrLn xmproc } 
-- }

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myRockDefaultPP :: PP
myRockDefaultPP = def
    {
        ppCurrent = xmobarColor "yellow"            "" . wrap "[" "]"
     ,  ppVisible = xmobarColor "lightyellow"       "" . wrap "<" ">"
     ,   ppHidden = xmobarColor "darkgrey"          "" . wrap "" ""
--     ,   ppLayout = xmobarColor "blue"     "lightblue" . wrap "{" "}"
     ,   ppLayout = xmobarColor "blue"     "lightblue" . myRockLayoutPrinter
     ,    ppTitle = xmobarColor "green"             "" . wrap "[" "]" . shorten 50
     ,   ppUrgent = xmobarColor "black"          "red" . xmobarStrip
     ,      ppSep = " * "
     ,    ppWsSep = " "
--     ,   ppExtras = [ date " %a %d %b %T %Y " ]
     ,    ppOrder = \(ws:l:t:xs) -> [l,ws,t] ++ xs
    }


--myRockPP h s = LIS.marshallPP s def
myRockPP :: Handle -> ScreenId -> PP
myRockPP h s = myRockDefaultPP
--myRockPP = xmobarPP
    {
       ppOutput = hPutStrLn h
    }

------------------------------------------------------------------------
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myRockWorkSpaces :: [WorkspaceId]
myRockWorkSpaces =
     [ 
        workspace01
      , workspace02
      , workspace03
      , workspace04
      , workspace05
      , workspace06
      , workspace07
      , workspace08
      , workspace09
     ] where
        workspace01 = "1:Main"
        workspace02 = "2:Web"
        workspace03 = "3:Editors"
        workspace04 = "4:Music"
        workspace05 = "5:Gimp"
        workspace06 = "6:Download"
        workspace07 = "7:Video"
        workspace08 = "8:Documents"
        workspace09 = "9:Others"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify.
--
main :: IO()
main = do
  putStrLn "Starting XMonad"
  nScreens <- LIS.countScreens
  hs       <- mapM (spawnPipe . xmobarCommandPanel nScreens) [0..nScreens -1]
--  xmonad $ withUrgencyHookC (SpawnUrgencyHook "***PRUEBA***") urgentConfig $ rockDefaults hs nScreens
  xmonad $ withUrgencyHook LibNotifyUrgencyHook $ rockDefaults hs nScreens

--urgentConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont }

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
     urgencyHook LibNotifyUrgencyHook w = do
         name     <- getName w
         Just idx <- fmap (W.findTag w) $ gets windowset
         --spawn ("echo \"" ++ show name ++ " workspace: " ++ show idx ++ "\" | xmessage -default okay -file -")
         safeSpawn "notify-send" [show name, "workspace: " ++ idx]
--         safeSpawn "xmessage" [show name, "workspace: " ++ idx]

--  xmproc <- spawnPipe myRockPanel
--  xmonad $ rockDefaults xmproc

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- nearest point of window
-- logHook = updatePointer (0.5, 0.5) (1, 1)
-- exact centre of window
-- logHook = updatePointer (0.5, 0.5) (0, 0)
-- near the top-left
-- logHook = updatePointer (0.25, 0.25) (0.25, 0.25)
-- within 110% of the edge
-- logHook = updatePointer (0.5, 0.5) (1.1, 1.1)
--
rockDefaults hs ns = def
  { 
      -- simple stuff
      terminal           = myRockTerminal
    , focusFollowsMouse  = myRockFocusFollowsMouse
    , clickJustFocuses   = myRockClickJustFocuses
    , borderWidth        = myRockBorderWidth
    , modMask            = myRockModMask
    , workspaces         = myRockWorkSpaces
    , normalBorderColor  = myRockNormalBorderColor
    , focusedBorderColor = myRockFocusedBorderColor

      -- key bindings
    , keys               = myRockKeys
    , mouseBindings      = myRockMouseBindings

      -- hooks, layouts
    , layoutHook         = myRockLayout
--    , manageHook         = myRockManageHook <+> manageMonitor myMonitor
    , manageHook         = myRockManageHook
--    , logHook            = myRockLogHook xmproc
--    , logHook            = do
--                             winset   <- gets windowset
--                             updatePointer (0.5, 0.5) (0, 0)  >> myRockLogHook hs ns
    , logHook            = updatePointer (0.5, 0.5) (0, 0)  >> myRockLogHook hs ns
    , startupHook        = myRockStartupHook
    , handleEventHook    = myRockEventHook
  }


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
-- Keys found into:
--         /usr/include/X11/XF86keysym.h
--
myRock_F2, myRock_F3, myRock_F4, myRock_F5, myRock_F6, myRock_F7, myRock_F8, myRock_F9 :: KeySym
myRock_F2 = 0x1008FF11   --XF86AudioLowerVolume
myRock_F3 = 0x1008FF13   --XF86AudioRaiseVolume
myRock_F4 = 0x1008FF12   --XF86AudioMute
myRock_F5 = 0x1008FF16   --XF86XK_AudioPrev
myRock_F6 = 0x1008FF17   --XF86XK_AudioNext
myRock_F7 = 0x1008FF14   --XF86XK_AudioPlay
myRock_F8 = 0x1008FF15   --XF86XK_AudioStop
myRock_F9 = 0x1008FF18   --XF86XK_Explorer



myRockKeys :: XConfig Layout ->  M.Map (KeyMask, KeySym) (X ())
myRockKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Swap the focused window and the master window
    [ ((modm                , xK_Return)  , windows W.swapMaster)

    -- launch a terminal     
    , ((modm .|. shiftMask  , xK_Return)  , spawn $ XMonad.terminal conf)

     -- Rotate through the available layout algorithms
    , ((modm                , xK_space)   , sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask  , xK_space)   , setLayout $ XMonad.layoutHook conf)

    -- Move focus to the next window
    , ((modm                , xK_Tab)     , windows W.focusDown)

    -- Move focus to the next/previous window
    , ((modm                , xK_Right)   , windows W.focusDown)
    , ((modm                , xK_Down)    , windows W.focusDown)
    , ((modm                , xK_Left)    , windows W.focusUp  )
    , ((modm                , xK_Up)      , windows W.focusUp  )

    -- Move focus to the master window
    , ((modm .|. shiftMask  , xK_Up)      , windows W.focusMaster  )

    -- Swap the focused window with the next/previous window
--    , ((modm .|. shiftMask  , xK_Right)   , windows W.swapDown  )
--    , ((modm .|. shiftMask  , xK_Left)    , windows W.swapUp    )

    -- Shrink/Expand the windows area
    , ((modm .|. controlMask, xK_Up)      , sendMessage Shrink)
    , ((modm .|. controlMask, xK_Right)   , sendMessage MirrorShrink)
    , ((modm .|. controlMask, xK_Down)    , sendMessage Expand)
    , ((modm .|. controlMask, xK_Left)    , sendMessage MirrorExpand)

    -- Increment the number of windows in the master area
    , ((modm                , xK_comma)   , sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm                , xK_period)  , sendMessage (IncMasterN (-1)))

    -- Function Fx keys.
    , ((0                   , myRock_F2) , spawn "amixer set Master 2%-")
    , ((0                   , myRock_F4) , spawn "amixer set Master toggle")
    , ((0                   , myRock_F3) , spawn "amixer set Master 2%+")
    , ((0                   , myRock_F5) , spawn "mpc --no-status prev")
    , ((0                   , myRock_F6) , spawn "mpc --no-status next")
    , ((0                   , myRock_F7) , spawn "mpc --no-status toggle")
    , ((0                   , myRock_F8) , spawn "mpc --no-status stop")
    , ((0                   , myRock_F9) , spawn "firefox")

    -- close focused window
    , ((modm .|. shiftMask  , xK_c)       , kill)
    , ((modm                , xK_b)       , broadcastMessage ToggleMonitor >> refresh)

    -- Change to One Screen
    , ((modm                , xK_d)       , toggledisplay)

    -- Change to Two Screens
    --, ((modm .|. shiftMask  , xK_d)       , setBG)

    -- Run  with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask  , xK_h)       , spawn ("echo \"" ++ help ++ "\" | xmessage -default okay -file -"))

    -- Resize viewed windows to the correct size
    , ((modm                , xK_n)       , refresh)

    -- launch dmenu
    , ((modm                , xK_p)       , spawn "exe=`~/.dmenu_custom -b -fn \"Boogaloo:size=16\" -nb black -nf yellow -sf yellow` && eval\"exec $exe\"")

    -- launch gmrun
    , ((modm .|. shiftMask  , xK_p)       , spawn "gmrun")

    -- Restart xmonad
    , ((modm                , xK_q)       , recompileXMonad)

    -- Quit xmonad
    , ((modm .|. shiftMask  , xK_q)       , io (exitWith ExitSuccess))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm                , xK_s)       , sendMessage ToggleStruts)
    , ((modm .|. shiftMask  , xK_s)       , sendMessage $ SetStruts [U,L] [minBound .. maxBound])

    -- Push window back into tiling
    , ((modm                , xK_t)       , withFocused $ windows . W.sink)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myRockMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myRockMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'Windows'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

