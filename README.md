# Xiaomi Robot Vacuum Card

> **Fork** of [tojolab/xiaomi-s20plus-vacuum-card](https://github.com/tojolab/xiaomi-s20plus-vacuum-card) with extended support for the **Xiaomi Robot Vacuum 5 Pro (OV21GL)** and general improvements.

A custom Lovelace card for Home Assistant that gives you full room-by-room control of your Xiaomi Robot Vacuum using the [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) integration.

<img width="512" height="851" alt="Image" src="https://github.com/user-attachments/assets/0893c9fb-bed0-48f8-ba0c-ac1337e859ce" />

---

## Features

- **Room selection** — tap individual rooms or use All / Clear; rooms are read directly from the vacuum's room map
- **Mode control** — Vacuuming, Mopping, Vacuuming & Mopping, Vacuuming before mopping
- **Suction level** — Silent, Standard, Strong, Turbo
- **Water output** — Off, Level 1, Level 2, Level 3
- **Mode-aware controls** — Suction disabled when Mopping-only; Water output disabled when Vacuuming-only
- **Water tank warnings** — chips appear automatically when clean water is empty or dirty water tank is full
- **Room filtering** — configure which rooms to show and in what order via `rooms:` config key
- **Auto entity discovery** — finds mode/suction/water select entities automatically; no manual entity IDs needed
- **LAN & Cloud mode** — works in both modes; in LAN mode without internet, battery and status chip are unavailable but all cleaning commands still work

---

## Supported Hardware

### Xiaomi Robot Vacuum S20+ (B108GL)
Uses `xiaomi_miot`. Rooms are read from the `vacuum_extend.room_info` attribute.

### Xiaomi Robot Vacuum 5 Pro (OV21GL)
Uses `xiaomi_miot` + [xiaomi_cloud_map_extractor](https://github.com/PiotrMachowski/Home-Assistant-custom-components-Xiaomi-Cloud-Map-Extractor).
Rooms are read from the camera entity's `rooms` attribute.
Room cleaning uses `vacuum.send_command` with `app_segment_clean`.
Water tank warnings use `vacuum.fault` attribute for reliable detection on this model.

Other Xiaomi MiOT vacuum models may work depending on which attributes they expose.

---

## Requirements

- Home Assistant (any recent version)
- [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) — installable via HACS

**For OV21GL / xiaomi_cloud_map_extractor support:**
- [xiaomi_cloud_map_extractor](https://github.com/PiotrMachowski/Home-Assistant-custom-components-Xiaomi-Cloud-Map-Extractor) — installable via HACS

---

## Installation

### Via HACS (recommended)

1. In HACS, click the three-dot menu (⋮) → **Custom repositories**
2. Enter `https://github.com/luchusnet/xiaomi-robot-vacuum-card` and select category **Lovelace**
3. Click **Add**
4. Search for **Xiaomi Robot Vacuum Card** → **Download**

### Manual

1. Download `xiaomi-robot-vacuum-card.js` from the [latest release](https://github.com/luchusnet/xiaomi-robot-vacuum-card/releases/latest)
2. Copy it to `/config/www/xiaomi-robot-vacuum-card.js` on your HA server
3. In HA → Settings → Dashboards → Resources, add:
   - URL: `/local/xiaomi-robot-vacuum-card.js`
   - Type: JavaScript module
4. Hard-refresh your browser (`Ctrl+Shift+R` / `Cmd+Shift+R`)

<img width="1280" height="692" alt="gif-capture" src="https://github.com/user-attachments/assets/49833681-7af3-4277-b679-02df7bcf00e9" />

---

## Configuration

### Minimal (xiaomi_miot only)

```yaml
type: custom:xiaomi-robot-vacuum-card
entity: vacuum.your_vacuum_entity
```

The card auto-discovers all helper entities (mode, suction, water selects) from the same device.

### Full config — OV21GL (xiaomi_cloud_map_extractor)

```yaml
type: custom:xiaomi-robot-vacuum-card
entity: vacuum.your_vacuum_entity
map_source:
  camera_entity: camera.your_vacuum_live_map   # from xiaomi_cloud_map_extractor
fan_select: select.your_vacuum_mode            # suction level entity
show_battery: true
show_status: true
rooms:                                         # optional: filter/reorder rooms
  - Living
  - Kitchen
  - Bedroom
```

> **OV21GL note:** the suction level entity is named `select.<vacuum>_mode` (options: Silent / Basic / Strong / Full Speed). Set it via `fan_select:` since auto-discovery looks for `_suction_level` suffix which this model doesn't use.

### All config options

| Key | Default | Description |
|-----|---------|-------------|
| `entity` | *(required)* | Vacuum entity from `xiaomi_miot` |
| `map_source.camera_entity` | — | Camera entity from `xiaomi_cloud_map_extractor` |
| `fan_select` | auto | Override suction level select entity |
| `mode_select` | auto | Override clean mode select entity |
| `water_select` | auto | Override water output select entity |
| `show_battery` | `true` | Show battery chip |
| `show_status` | `true` | Show status chip |
| `title` | vacuum name | Custom card title |
| `rooms` | all rooms | List of room names or IDs to show (in order) |

---

## Known Limitations

- Requires the `xiaomi_miot` integration (and optionally `xiaomi_cloud_map_extractor`)
- Room names come from your vacuum's map (set up via the Mi Home app); default names like "Room 1" are not returned
- Tested on Xiaomi S20+ (B108GL) and Xiaomi Robot Vacuum 5 Pro (OV21GL)

---

## Troubleshooting

### Rooms not showing up?
Rooms are only available after being renamed in the Xiaomi Home app. Default names (Room 1, Room 2…) are not returned by the API.

### Suction section not visible on OV21GL?
Add `fan_select: select.<your_vacuum>_mode` to your card config.

### Water tank warnings not showing on OV21GL?
This model reports water faults via the `vacuum.fault` attribute. Make sure you're on the latest version of this fork which handles OV21GL-specific fault detection.

### Card shows "Working" but vacuum is already docked?
Fixed in this fork: the card previously waited up to 30 minutes to release the cleaning lock when the status sensor had no activity during the session. Now it releases immediately when the vacuum is detected as docked or charged.

---

## Changelog (fork)

- **v1.0.3** — Rename to `xiaomi-robot-vacuum-card`; fix stale mode unlock when docked/charged; water tank warning improvements for OV21GL; `xiaomi_cloud_map_extractor` support

---

## License

MIT — see [LICENSE](LICENSE)
