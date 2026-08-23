# MrNewbPhoneTracker

Job-gated tracker item. Enter a phone number, get a waypoint if that player is online.

[Documentation](https://mrnewb.github.io/docs/mrnewbphonetracker) · [GitHub](https://github.com/MrNewb/MrNewbPhoneTracker) · [Discord](https://discord.gg/mrnewbscripts)

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib), [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge), and a supported phone resource.

```cfg
ensure ox_lib
ensure Newb_Bridge
ensure MrNewbPhoneTracker
```

Item def: [docs](https://mrnewb.github.io/docs/mrnewbphonetracker/install).

## Config

`configs/config.lua` — `RequiredJob` (job name → minimum grade, default `police = 0`; array `{ 'police', 'sheriff' }` also works), `TrackerItem` (default `tracker`), `PingCooldown` (seconds between pings per player, default `10`; `0` disables), `Utility.Debug`.

Using the item opens a handheld GPS overlay. Digits only, max 10. A hit closes the device and drops a waypoint; a miss stays on the glass.

Turn `Debug` off on a live server.

Phones: gksphone, lb-phone, NPWD, okokPhone, qs-smartphone, qb-phone, qs-smartphone-pro, roadphone, yseries.

qb-phone / charinfo lookups go through `OpenFindSourceByCharPhone` in `resource/open/server/phone_lookup.lua`.
