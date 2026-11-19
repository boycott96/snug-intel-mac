<div align="center">

[简体中文](README.md) · **English**

<img src="Assets/AppIcon/AppIcon-1024.png" width="128" alt="Snug icon">

# Snug Intel Mac

**A native-grade Mac experience, right on your phone**

Built for UU Remote<br>Native portrait display · Native gestures · App Library · Fits every phone

[![Repository](https://img.shields.io/badge/GitHub-snug--intel--mac-blue)](https://github.com/boycott96/snug-intel-mac) ![Intel x86_64](https://img.shields.io/badge/Intel-x86__64-success) ![macOS 13+](https://img.shields.io/badge/macOS-13%2B-blue) [![License MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)

[Download](#-download) · [Native Experience](#-native-experience) · [App Library](#-app-library) · [Fit](#-fits-every-app-and-phone) · [Comparison](#-compared-with-alternatives) · [Installation](#-installation) · [Usage](#-usage) · [Limitations](#-known-limitations) · [Development](#-development)

<br>

<img src="Assets/README/phone-app-library.865fc506.png" width="30%" alt="App Library: running apps with their windows"> <img src="Assets/README/phone-demo.2cee4e81.webp" width="30%" alt="Live demo: opening a window, typing commands on the pop-up keyboard, resuming a session, one-finger scrolling, returning to the list"> <img src="Assets/README/phone-context-menu.997dd70f.png" width="30%" alt="Long-press context menu">
<p><sub>App Library · Live demo · Long-press context menu</sub></p>

</div>

> **Snug Intel Mac is an independently maintained, long-term project for Intel (x86_64) Macs running macOS 13+.** Its sole project entry point is [boycott96/snug-intel-mac](https://github.com/boycott96/snug-intel-mac). Development and source builds use the default `main` branch.

> Historically derived from [zephyr4123/snug](https://github.com/zephyr4123/snug), whose predecessor is [aoyamashou/UUyc-companion](https://github.com/aoyamashou/UUyc-companion) (UU Remote Companion by AoyamaShou, MIT License). Snug was redesigned around the phone screen starting with version 2.0. The original copyright notices and commit history are preserved; these links are attribution only, not download sources for this project.

> **Compatibility: verified on Intel Mac · macOS 13 (Ventura).** Builds and tests were completed on macOS 13.7.8 (22H730), x86_64, and the user has confirmed it works on that machine. See the [compatibility verification record](docs/macos-13-compatibility.md) for evidence and untested scenarios. Runtime behavior on macOS 14 or later has not been tested; Apple silicon is outside this project's target scope. The feature descriptions and images below illustrate usage, not a claim that every feature has been individually retested on the target environment.

## 📥 Download

<img src="Assets/AppIcon/AppIcon-1024.png" width="88" align="left" alt="Snug icon">

**Snug Intel Mac · Intel x86_64 / macOS 13+**<br>This repository has not published any binary installers. Building from source is recommended.<br>Apple signing or notarization is not promised; historical test builds used local ad-hoc signing.

<br clear="left">

| Source | Notes | Entry point |
| :--- | :--- | :--- |
| **Source (recommended)** | Default `main` branch; build requirements below | [Repository](https://github.com/boycott96/snug-intel-mac) |
| **GitHub Releases** | The sole binary release source for this project; no releases yet | [View releases](https://github.com/boycott96/snug-intel-mac/releases) |

Upstream installers and CDNs are not download sources for this project.

> On Windows? A community port is available; see [Community Ports](#-community-ports) below.

## ✨ Native Experience

UU Remote scales your entire desktop down to fit the phone, shrinking text and controls several times over. Snug adds a dedicated portrait display for the phone, where your Mac's windows appear at a phone-native scale, looking and behaving like native apps.

<p align="center"><img src="Assets/README/compare-uu-original.cf4158d1.png" width="36%" alt="UU Remote alone: the whole desktop squeezed onto the phone"> <img src="Assets/README/phone-claude-code.93e21d9d.png" width="36%" alt="With Snug: the window fills the screen with larger text"><br><sub>Same content · Left: UU Remote alone · Right: with Snug</sub></p>

### Native Portrait Display

- **A dedicated portrait screen**: once your phone connects, "Snug 手机屏" (Snug Phone Screen) appears in UU Remote's screen list, matching your phone's proportions in 2x HiDPI
- **Full-screen windows**: the selected window takes over the entire screen
- **Larger text**: Ghostty, Terminal, iTerm2, VS Code, Cursor, and Zed enlarge their text automatically, remembered per app

### Native Gestures

UU Remote's mobile client carries over trackpad gesture conventions. On the phone screen, Snug reinterprets them the way phones are meant to be used.

| On the phone | UU Remote alone | Snug phone screen |
| :--- | :--- | :--- |
| One-finger swipe | Mouse drag, often selecting text by accident | Scrolls, with momentum after release |
| Long-press, then drag | Mouse drag | Selects text |
| Long-press, then release | Regular click | Opens the context menu |

- Applies only within the phone screen; other displays and the Mac's own trackpad and mouse are unaffected

### Works Like an iPhone

| iPhone | Snug phone screen |
| :--- | :--- |
| App Library | The [App Library](#-app-library): the home page, for finding, opening, and managing the apps on your Mac |
| Home indicator | Bottom indicator bar, returning to the App Library |
| "‹ Back" in the top-left corner | "‹ App name" in the top-left corner, returning to the current window |

### Screenshots

Turn on Screenshot (「截图」) in Snug Settings and a camera button appears on the left of the bottom indicator bar. Tap it to capture the window filling the phone screen and copy it to the Mac's clipboard, ready to paste into any app. You get the window's native pixels, unaffected by remote image compression.

- **Crop**: after a capture, a thumbnail appears in the bottom-left corner; tap it to crop. The whole image is selected by default — drag a corner or edge inward, then tap Done (「完成」) to replace the screenshot in the clipboard with the selection
- **Permission**: requires the separate Screen & System Audio Recording permission (Screen Recording on macOS 13 and 14); click Authorize… (「授权…」) in Snug Settings, then reopen Snug when macOS asks. It is independent of the Accessibility permission
- **Off by default**: when it is off, the indicator bar shows no camera button and no recording permission is needed

## 📱 App Library

The home page of the phone screen (「App 资源库」), for managing your Mac's apps from the phone: find, open, switch, create, close, and quit, without going back to your desk.

- **Running** (「运行中」): each running app has its own card, with its windows listed beneath it. Every window is here, whichever display or Space it's on, even full-screen or minimized
- **All** (「全部」): a grid of every app on your Mac, sorted by name; tap an app that isn't running to launch it
- **Search**: matches app names and window titles, in Chinese, English, full pinyin, or pinyin initials, so "bwl" finds Notes (「备忘录」)

<p align="center"><img src="Assets/README/phone-app-library.865fc506.png" width="30%" alt="Running: the app whose window is on the phone screen is listed first"> <img src="Assets/README/phone-all-apps.7d4ada60.png" width="30%" alt="All: a grid of every app on the Mac"> <img src="Assets/README/phone-search.d365e194.png" width="30%" alt="Search: typing bwl finds Notes"><br><sub>Running · All · Searching by pinyin initials</sub></p>

| Action | How |
| :--- | :--- |
| Open a window | Tap a window to fill the phone screen; tap an app to open its most recently used window |
| New window | Tap "New Window" on the app's card; the new window opens at phone width |
| Close a window | Tap the close button next to the window, then tap again to confirm |
| Quit an app | Tap "Quit" on the app's card, then tap again to confirm; if it hasn't quit after 10 seconds, you can force quit it |
| Save unsaved changes | The save prompt that appears when closing or quitting shows up on the phone screen, so you can answer it there |
| Exit the phone screen | Tap "Exit Phone Screen" at the top right, then tap again to confirm; windows return to where they were and the phone screen is removed for the rest of this session. It comes back next session (reconnecting within 15 seconds of disconnecting still counts as this session) |

## 📐 Fits Every App and Phone

### Every App Works and Fills the Screen

Snug brings the Mac's windows themselves to the phone screen, so every app works as it is, with no tie to any AI vendor: Claude Code in a terminal and Codex in the ChatGPT desktop app work just as they do at your desk.

Some apps enforce a minimum width and can't shrink to the phone screen. Snug first fits the window to the phone's width; if the app won't go any narrower, it switches the phone screen to a resolution just wide enough to hold it, then fills the screen again.

- Every window is shown in full, never partly cut off
- The picture scales proportionally without distortion, and taps land exactly where you expect
- Text in such windows is slightly smaller; pinch to zoom on the phone

<p align="center"><img src="Assets/README/phone-chatgpt.a28ef053.png" width="36%" alt="Codex in the ChatGPT desktop app, filling the Snug phone screen"> <img src="Assets/README/phone-fit-settings.4e526ad6.png" width="36%" alt="System Settings, which enforces a minimum width, filling the phone screen completely"><br><sub>Left: Codex in the ChatGPT desktop app (file links redacted) · Right: System Settings enforces a minimum width, yet still fills the screen completely</sub></p>

### Every Phone, Edge to Edge

UU Remote scales the picture proportionally to fit the phone, leaving black bars when the proportions don't match. Snug sizes the phone screen to your phone model, so the picture fills it exactly.

- **Any platform, any brand**: fully supports iPhone, iPad, and Android devices from every major brand, with 800 built-in models across 17 brands
- **Custom**: if your model isn't listed, enter its screen resolution or aspect ratio

<p align="center"><img src="Assets/README/phone-models.3137ee0e.png" width="36%" alt="Phone model page: the current model, a custom resolution, and models listed by brand"><br><sub>Phone model: models listed by brand, or enter a custom resolution</sub></p>

## 🆚 Compared with Alternatives

| Approach | Limitation | Snug |
| :--- | :--- | :--- |
| **Remote control in AI assistants** | Limited to that vendor's own AI sessions | Works with any terminal or app; see [Every App](#every-app-works-and-fills-the-screen) |
| **UU Remote's built-in terminal** | Separate from local terminals; processes linger after disconnecting | Uses the terminal windows already open on your Mac |

- **Remote control in AI assistants**: for example, Claude Remote Control and Codex in ChatGPT, each tied to a single product
- **UU Remote's built-in terminal**: runs in UU Remote's own tmux, so work in progress on your Mac (such as Claude Code running in your terminal) cannot be picked up there

## 📦 Installation

> **Requirements**: an Intel (x86_64) Mac, targeting macOS 13 or later. Verified on macOS 13.7.8; runtime behavior on other system versions has not been verified. Install [UU Remote](https://uuyc.163.com/) on the Mac being controlled; only UU Remote is needed on the phone.

**Build and install from source (recommended)**

Requires **Swift 6.1+ and a macOS 14+ SDK**. See the [development guide](docs/development.md) for toolchain setup and the [compatibility verification record](docs/macos-13-compatibility.md) for the local macOS 13 reproduction command. The build SDK version is not the minimum runtime OS version.

```bash
git clone https://github.com/boycott96/snug-intel-mac.git
cd snug-intel-mac && scripts/snug install
```

This uses the default `main` branch; no additional branch checkout is needed. After installation, follow the welcome window to grant Accessibility permission; local ad-hoc re-signing may require granting it again. The app and menu bar still use the name Snug. Open it again to access Settings.

**Updates**: this project uses only [this repository's GitHub Releases](https://github.com/boycott96/snug-intel-mac/releases) for releases and updates. Legacy `updateSource: "tencent"` settings migrate to `"github"`; Tencent Cloud is no longer an option. No binaries have been released, and end-to-end updates using this repository's release packages have not been verified. For now, update by building from source; one-click updates are not promised.

<div align="center">
<img src="Assets/README/welcome.529d7d28.png" width="30%" alt="Welcome window"> <img src="Assets/README/settings-ready.a76a5b8c.png" width="30%" alt="Settings"> <img src="Assets/README/about.5534d9dc.png" width="30%" alt="About: version, software update, and update source">
<p><sub>Welcome window · Settings · About</sub></p>
</div>

<details>
<summary>Migrating from UU Remote Companion</summary>

Running both at the same time causes conflicts, so Snug prompts you to quit the old app at launch. If you enabled its watchdog helper, also run:

```bash
launchctl bootout gui/$(id -u)/com.corndog.uudisplay.watchdog-agent
rm ~/Library/LaunchAgents/com.corndog.uudisplay.watchdog-agent.plist
```

</details>

## 🧭 Usage

1. **Switch screens**: once a phone or tablet connects, choose "Snug 手机屏" (Snug Phone Screen) in UU Remote's screen list

   <img src="Assets/README/uu-screen-picker.212fdbe9.png" width="50%" alt="UU Remote's screen list, showing display 3: Snug Phone Screen">

2. **Choose your phone model** (first time only): in the top-right corner of the App Library or in Snug's settings. Then switch to another screen in UU Remote and back, and the phone screen fills your display at the new proportions
3. **Pick an app or window**: tap an app or window in the App Library and it fills the screen; apps that aren't running are launched
4. **Switch windows**: tap the bottom indicator bar to return to the App Library; choosing another window returns the previous one to its place
5. **End the session**: windows return to their original positions, text sizes are restored, and the phone screen is removed

## 🔒 Isolation and Restoration

- **Only the phone screen is touched**: the main display, other screens, and other windows are left alone; when you are not on the phone screen, UU Remote behaves exactly as it always has
- **Record first, then change**: each window's original position and text size are recorded in advance, so they can be restored even if Snug quits unexpectedly
- **Restored even when a window is closed directly**: if you close a window directly on your phone, the next time the app opens it at the phone-screen size, Snug moves it back and restores its text size
- **Unresponsive apps are left as they are**: if an app stops responding, Snug does not force its window to move and explains why on screen
- **No data collection**: apart from checking for updates, Snug connects to no servers and collects no data; screenshots only go to the Mac's clipboard and are not kept

## 🚧 Known Limitations

| Limitation | Details |
| :--- | :--- |
| Relies on undocumented macOS APIs | May break after a major macOS update |
| Portrait only | A tablet held in landscape gets the standard UU Remote experience; landscape support for tablets is planned |
| Not an official NetEase product | Unaffiliated with UU Remote or its developer; UU Remote updates may affect some features |
| The phone screen may occasionally remain after a session ends | Occurs when the system log misses the end of the stream; the menu bar still shows the session as active (「远程中」). Turn off the phone screen in Settings to restore |
| VS Code and Cursor may remember the enlarged text size if a window is closed on the phone with a shortcut or menu | If the text looks too large when you reopen it after the session, press ⌘- to restore it (the phone screen shows how many steps when the window closes). With gestures on, tapping the window's own close button, or closing it from the app library, is not affected |
| On a Mac with no display attached, you can't switch back to the original screen | macOS provides a default screen only when no display is connected, and removes it as soon as the phone screen appears. Exit the phone screen from the top right of the app library to get the original screen back |

The technical reasons behind each limitation are explained in [How It Works](docs/how-it-works.md#已知限制的技术原因) (in Chinese).

## 🔧 Development

```bash
scripts/snug check     # build and run all tests
scripts/snug install   # build, install, and launch
```

- The code is organized in three layers: `SnugCore` (pure logic) → `SnugSystem` (system interfaces) → `Snug` (UI)
- Packaging, releases, launch arguments, and data locations: [Development guide](docs/development.md) (in Chinese)
- Connection detection, window placement, and gesture translation: [How It Works](docs/how-it-works.md) (in Chinese)

## 🧹 Uninstall

1. Quit Snug from the menu bar (windows are restored first)
2. Move Snug from Applications to the Trash
3. Optional: remove its settings and logs with `rm -rf ~/Library/Application\ Support/Snug ~/Library/Logs/Snug.log*`
4. Optional: remove Snug from Accessibility in System Settings, and from Screen & System Audio Recording if you turned on Screenshot

## 🌐 Community Ports

| Platform | Project | Maintainer | Notes |
| :--- | :--- | :--- | :--- |
| Windows 10 / 11 | [snug-win](https://github.com/nicocart/snug-win) | [nicocart](https://github.com/nicocart) | Ported from Snug 2.5.0; C# / .NET 8 / WPF |

Community ports are developed, released, and maintained independently by their authors. This repository develops and tests the macOS version only and has not tested these ports; please report any issues to the corresponding repository.

## 🙏 Acknowledgments

First and foremost, we extend our sincere respect to **[UU Remote](https://uuyc.163.com/)**.

- **Exceptional quality**: stable connections, responsive control, and freely adjustable image quality and frame rate. Remote control spans encoding, transport, and connectivity across networks, among many other engineering challenges; reaching a standard that everyday work can depend on is a formidable technical achievement in its own right.
- **Entirely free**: a product with so high a technical barrier remains free for everyone. That goes well beyond generosity; it is a genuine gift to the entire remote-access ecosystem. This openness is what allows the community to keep building on it, from companion apps and one-finger scrolling to virtual displays, and Snug grew from it as well.

With heartfelt thanks.

We are equally grateful to the following projects and contributors:

- [UUyc-companion](https://github.com/aoyamashou/UUyc-companion) (MIT): by AoyamaShou, Snug's predecessor
- [Better Remote](https://github.com/pincc-debug/better-remote) (MIT): by pincc-debug, the approach to one-finger scrolling in UU Remote
- [PermissionFlow](https://github.com/jaywcjlove/PermissionFlow) (MIT): by jaywcjlove (小弟调调), the permission onboarding and drag-to-authorize panel
- [FreeDisplay](https://github.com/huberdf/FreeDisplay) (MIT): by huberdf, the `CGVirtualDisplay` interface declarations
- Community PR authors: bubble, gencheng liu, and Rongzheng Liu (#10, reading UU Remote windows in full-screen Spaces)
- The virtual display implementation draws on [DeskPad](https://github.com/Stengo/DeskPad), [Side Screen](https://github.com/tranvuongquocdat/SideScreen), and Chromium

## 🔗 Project Links

[Repository](https://github.com/boycott96/snug-intel-mac) · [Releases](https://github.com/boycott96/snug-intel-mac/releases) · [Issues](https://github.com/boycott96/snug-intel-mac/issues)

## 📄 License

[MIT](LICENSE) © 2026 AoyamaShou, © 2026 zephyr4123
