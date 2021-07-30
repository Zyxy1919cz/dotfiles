-- Manage IMPORTS
import XMonad
import System.Exit
import Graphics.X11.ExtraTypes.XF86

-- DATA
import Data.Monoid
import qualified Data.Map        as M

-- HOOKS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, docks)

-- LAYOUT
import XMonad.Layout.Spacing

-- UTILS
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

-- DATA structures and DBUS
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows (getName)
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)

myFont :: String
myFont = "Meslo LG S"

myTerminal      :: String
myTerminal      = "tilix"

myEditor :: String
myEditor = "emacsclient -c -a 'emacs'"

myBrowser :: String
myBrowser = "firefox"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   :: Dimension
myBorderWidth   = 0

-- My ModMask
myModMask       :: KeyMask
myModMask       = mod1Mask

-- My border olors
myNormalBorderColor :: String
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor :: String
myFocusedBorderColor = "#ff0000"

-- My Workspaces
myWorkspaces :: [String]
myWorkspaces    = ["<fn=2>\61461</fn>","<fn=2>\59205</fn> ","<fn=2>\59145</fn> ","4:\61888","\fa9e","6","7","8","9"]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Volume control
    [ ((0                 , xF86XK_AudioRaiseVolume), spawn "amixer -q sset Master 4%+")
    , ((0                 , xF86XK_AudioLowerVolume), spawn "amixer -q sset Master 4%-")
    , ((0                 , xF86XK_AudioMute    )   , spawn "amixer set Master toggle")

    -- Brightness control
    , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +10%")
    , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")

    -- Start Flameshot
    --GUI
    , ((modm              , xK_Print ), spawn "flameshot gui")

    , ((modm .|. shiftMask, xK_Print ), spawn "flameshot full -p ~/Main/Documents/")

    -- launch a terminal
    , ((modm .|. shiftMask, xK_t), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "rofi -show drun")

    -- launch Doom emacs
    , ((modm .|. shiftMask, xK_d), spawn myEditor)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

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

------------------------------------------------------------------------
-- Layouts:

myLayout = spacingRaw True (Border 0 2 2 2) True (Border 2 3 3 3) True (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

myEventHook = mempty
------------------------------------------------------------------------
-- Status bars and logging
--
myLogHook = return ()

------------------------------------------------------------------------
-- My event log for polybar

myEventLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

  where fmt currWs ws
          | currWs == ws = "[" ++ ws ++ "]"
          | otherwise    = " " ++ ws ++ " "
        sort' = sortBy (compare `on` (!! 0))
------------------------------------------------------------------------
-- Startup hook

myStartupHook = do
    spawnOnce "picom &"
    spawnOnce "pacwall -u -g &"
    spawnOnce "flameshot &"
    spawnOnce "eww daemon &"
    spawnOnce "emacs --daemon &"
    spawnOnce "sh $HOME/.config/polybar/launch.sh &"


------------------------------------------------------------------------
-- Xmonad stratup

main = do
  forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do
    safeSpawn "mkfifo" ["/tmp/" ++ file]

  xmonad $ docks defaults
        {
          manageHook = manageDocks <+> manageHook defaults,
          layoutHook = avoidStruts $ layoutHook defaults,
          logHook = myEventLogHook
        }

--  do
--  forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> safeSpawn "mkfifo" ["/tmp/" ++ file]

--  xmonad $ docks defaults {
--      manageHook = manageDocks <+> manageHook defaults,
--      layoutHook = avoidStruts $ layoutHook defaults
--    }

defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
