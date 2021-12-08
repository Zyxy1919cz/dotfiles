-- DATA

import Data.Function (on)
import Data.List (sortBy)
import qualified Data.Map as M
import Data.Monoid
import System.Exit (exitSuccess)
import XMonad
-- HOOKS

-- LAYOUT

-- UTILS

import XMonad.Actions.DynamicProjects
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import qualified XMonad.Util.EZConfig as EZ
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Paste (pasteSelection)
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------
-- Xmonad main IO function

main :: IO ()
main =
  xmonad
    . dynamicProjects projects
    . docks
    . ewmh
    $ def
      { modMask = mod1Mask,
        focusFollowsMouse = True,
        borderWidth = 0,
        normalBorderColor = "#dddddd",
        focusedBorderColor = "#ff0000",
        terminal = "kitty",
        workspaces = myWorkspaces,
        layoutHook = myLayout,
        handleEventHook = fullscreenEventHook,
        manageHook = manageDocks <+> myManageHook,
        logHook = dynamicLog,
        startupHook = myStartupHook
      }
      `EZ.additionalKeysP` additionalKeys'
      `EZ.additionalMouseBindings` additionalMouseBindings'

------------------------------------------------------------------------
-- Startup hook
myWorkspaces :: [String]
myWorkspaces = ["wsGEN", "wsBRW", "wsTER", "wsCOD", "wsMED", "wsSYS"] ++ map show [7 .. 9]

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xsetroot -cursor_name LyraR-cursors"
  spawnOnce "picom &"
  spawnOnce "pacwall -u -g &"
  spawnOnce "emacs --daemon --with-modules &"
  spawnOnce "eww daemon &"
  spawnOnce "flameshot &"
  spawnOnce "bash $HOME/.config/polybar/launchpolybar.sh &"

------------------------------------------------------------------------
-- Layouts:

myLayout = avoidStruts $ spacingRaw True (Border 2 2 2 2) True (Border 2 3 3 3) True (tiled ||| Full)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

------------------------------------------------------------------------
-- Status bars and logging
--
--myLogHook = return ()

myManageHook =
  composeAll
    [ className =? "Gimp" --> doFloat,
      stringProperty "WM_WINDOW_ROLE" =? "gimp-toolbox" --> doFloat,
      className =? "Pinentry" --> doFloat,
      className =? "brave-browser" --> doShift "wsBRW"
    ]
    <+> namedScratchpadManageHook myScratchpads

------------------------------------------------------------------------
-- My Projects

projects :: [Project]
projects =
  [ Project
      { projectName = "org",
        projectDirectory = "~/Main/Documents/org",
        projectStartHook = Just $ do
          spawn "emacsclient -c -a 'emacs'"
      },
    Project
      { projectName = "",
        projectDirectory = "~/Main/Documents",
        projectStartHook = Just $ do
          spawn "termite -e htop"
      }
  ]

-- My Scratchpads

myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS "notes" spawnNotes findNotes manageNotes
  ]
  where
    spawnNotes = "emacsclient -nc --frame-parameters='(quote (name . \"emacsnotes\"))' --eval '(doom/set-frame-opacity 100)' '~/Main/Documents/org/notes.org'"
    findNotes = title =? "emacsnotes"
    manageNotes = customFloating $ W.RationalRect 0.59 0.09 0.4 0.5

-- Key bindings. Add, modify or remove key bindings here.
--

additionalKeys' :: [(String, X ())]
additionalKeys' =
  windowsAndWorkspace
    <> applications
    <> system
  where
    windowsAndWorkspace :: [(String, X ())]
    windowsAndWorkspace =
      [ ("M-S-c", kill),
        ("M-<Space>", sendMessage NextLayout),
        ("M-<Tab>", windows W.focusDown),
        ("M-j", windows W.focusDown),
        ("M-k", windows W.focusUp),
        ("M-m", windows W.focusMaster),
        ("M-<Return>", windows W.swapMaster),
        ("M-S-j", windows W.swapDown),
        ("M-S-k", windows W.swapUp),
        ("M-n", refresh),
        ("M-h", sendMessage Shrink),
        ("M-l", sendMessage Expand),
        ("M-t", sendMessage ToggleStruts),
        ("M-S-t", withFocused $ windows . W.sink)
      ]
    applications :: [(String, X ())]
    applications =
      [ ("M-p", spawn "rofi -show drun"),
        ("M-S-l", spawn "xsecurelock 2>&1 | tee -a /tmp/xsecurelock.log & disown"),
        ("M-S-b", spawn "brave"),
        ("M-S-<Return>", spawn "kitty"),
        ("M-<Print>", spawn "flameshot gui"),
        ("M-S-<Print>", spawn "flameshot full -p ~/Main/Documents"),
        ("M-S-d d", spawn "emacsclient -c -a 'emacs' "),
        ("M-S-d e", spawn "emacsclient -c -a '' --eval '(ranger)'"),
        ("M-S-d t", spawn "emacsclient -c -a '' --eval '(vterm)'"),
        ("M-s n", namedScratchpadAction myScratchpads "notes"),
        ("M-s t", namedScratchpadAction myScratchpads "test")
      ]
    system :: [(String, X ())]
    system =
      [ ("<XF86KbdBrightnessUp>", spawn "brightnessctl set +10%"),
        ("<XF86KbdBrightnessDown>", spawn "brightnessctl set 10%-"),
        ("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 4%-"),
        ("<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 4%+"),
        ("<XF86AudioMute>", spawn "amixer set Master toggle"),
        ("M4-<Space>", spawn "~/.local/bin/layout_switch.sh"),
        ("<Insert>", pasteSelection),
        ("M-S-q", io exitSuccess),
        ("M-q", spawn "xmonad --recompile; xmonad --restart")
      ]
        ++ [ (otherModMask ++ "M-" ++ key, action tag)
             | (tag, key) <- zip myWorkspaces (map show [1 .. 9]),
               (otherModMask, action) <-
                 [ ("", windows . W.view),
                   ("S-", windows . W.shift)
                 ]
           ]
        ++ [ (otherModMask ++ "M-" ++ key, screenWorkspace screen >>= flip whenJust (windows . action))
             | (key, screen) <- zip ["w", "e", "r"] [0 ..],
               (otherModMask, action) <-
                 [ ("", W.view),
                   ("S-", W.shift)
                 ]
           ]

additionalMouseBindings' :: [((ButtonMask, Button), Window -> X ())]
additionalMouseBindings' =
  [ ( (mod1Mask, button1),
      \w ->
        focus w >> mouseMoveWindow w
          >> windows W.shiftMaster
    ),
    ( (mod1Mask, button2),
      \w ->
        focus w >> mouseResizeWindow w
          >> windows W.shiftMaster
    )
  ]
