# MrNewbPhoneTracker

Job-gated tracker item. Punch in a phone number on the handheld GPS; if that player is online you get a waypoint.

[Documentation](https://mrnewb.github.io/docs/mrnewbphonetracker) · [Install guide](https://mrnewb.github.io/docs/mrnewbphonetracker/install) · [Tebex](https://mrnewbscripts.tebex.io/) · [Discord](https://discord.gg/mrnewbscripts)

![In-game handheld GPS overlay](.github/assets/preview.jpg)

A GPS sitting in the world with a glass screen and keypad. Escape closes it. A successful ping closes it too and puts the mark on the map. A miss stays on the device so you can try another number.

## Features

- Job-gated item use (`police` any grade by default)
- Digits-only input, max 10
- Server-enforced ping cooldown (timer starts on dial, misses included)
- Waypoint plus a timed blip on a hit
- Phone adapters: gksphone, lb-phone, NPWD, okokPhone, qs-smartphone, qb-phone, qs-smartphone-pro, roadphone, yseries
- Open qb-phone / charinfo lookup if your stack stores numbers somewhere else

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib), [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge), and a supported phone resource started **before** this script. Item and image: [install guide](https://mrnewb.github.io/docs/mrnewbphonetracker/install).

```cfg
ensure ox_lib
ensure Newb_Bridge
ensure lb-phone
ensure MrNewbPhoneTracker
```

Add the `tracker` item. Icon is `[INSTALL]/images/tracker.png`. Do not add `server.export`.

## Config

`configs/config.lua`:

- `RequiredJob` — who can use it (`police = 0`, or a list)
- `TrackerItem` — default `tracker`
- `PingCooldown` — seconds per player (default `10`, `0` disables)
- `Utility.Debug` — leave `false` live

qb-phone / charinfo: `OpenFindSourceByCharPhone` in `resource/open/server/phone_lookup.lua`.

Phone list and callback: [documentation](https://mrnewb.github.io/docs/mrnewbphonetracker).
