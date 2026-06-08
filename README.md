# Xiaomi Robot Vacuum S20+ Card

A custom Lovelace card for Home Assistant that gives you full room-by-room control of your Xiaomi Robot Vacuum using the [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) integration — with extended support for the **Xiaomi Robot Vacuum 5 Pro** (OV21GL) via [xiaomi_cloud_map_extractor](https://github.com/PiotrMachowski/Home-Assistant-custom-components-Xiaomi-Cloud-Map-Extractor).

<img width="512" height="851" alt="Image" src="https://github.com/user-attachments/assets/0893c9fb-bed0-48f8-ba0c-ac1337e859ce" />

---

## Features

- **Room selection** - tap individual rooms or use All / Clear; rooms are read directly from the vacuum's room map
- **Mode control** - Vacuuming, Mopping, Vacuuming & Mopping, Vacuuming before mopping
- **Suction level** - Silent, Standard, Strong, Turbo
- **Water output** - Off, Level 1, Level 2, Level 3
- **Mode-aware controls** - Suction disabled when Mopping-only mode is selected; Water output disabled when Vacuuming-only mode is selected
- **Water tank warnings** - chips appear automatically when clean water is empty or dirty water tank is full
- **Room filtering** - optionally configure which rooms to show and in what order via `rooms:` config key
- **Auto entity discovery** - finds mode/suction/water select entities automatically via device registry; no manual entity IDs needed
- **LAN & Cloud mode support** - works in both Cloud mode and LAN mode; note that in LAN mode without internet, battery percentage and status chip are unavailable (all cleaning commands still work)

---

## Supported Hardware

### Xiaomi Robot Vacuum S20+ (B108GL) — original support
Uses the `xiaomi_miot` integration. Rooms are read from the `vacuum_extend.room_info` attribute.

### Xiaomi Robot Vacuum 5 Pro (OV21GL) — extended support
Uses `xiaomi_miot` + [xiaomi_cloud_map_extractor](https://github.com/PiotrMachowski/Home-Assistant-custom-components-Xiaomi-Cloud-Map-Extractor).
Rooms are read from the camera entity's `rooms` attribute exposed by `xiaomi_cloud_map_extractor`.
Room cleaning uses `vacuum.send_command` with `app_segment_clean`.

Other Xiaomi MiOT vacuum models may work with either path depending on which attributes they expose.

---

## Requirements

- Home Assistant (any recent version)
- [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) custom integration (installable via HACS)

**For Xiaomi Robot Vacuum 5 Pro / xiaomi_cloud_map_extractor support:**
- [xiaomi_cloud_map_extractor](https://github.com/PiotrMachowski/Home-Assistant-custom-components-Xiaomi-Cloud-Map-Extractor) custom integration (installable via HACS)

---

## Installation

### Via HACS (recommended)

1. In HACS, click the three-dot menu (⋮) → **Custom repositories**
2. Enter `https://github.com/tojolab/xiaomi-s20plus-vacuum-card` and select category **Dashboard**
3. Click **Add**
4. Search for **Xiaomi Robot Vacuum S20+ Card** → **Download**

After installation, add the card to your dashboard.

### Manual

1. Download `xiaomi-s20plus-vacuum-card.js` from the [latest release](https://github.com/tojolab/xiaomi-s20plus-vacuum-card/releases/latest)
2. Copy it to `/config/www/xiaomi-s20plus-vacuum-card.js` on your HA server
3. In HA → Settings → Dashboards → Resources, add:
   - URL: `/local/xiaomi-s20plus-vacuum-card.js`
   - Type: JavaScript module
4. Hard-refresh your browser (Ctrl+Shift+R)

<img width="1280" height="692" alt="gif-capture" src="https://github.com/user-attachments/assets/49833681-7af3-4277-b679-02df7bcf00e9" />

---

## Configuration

### Minimal — Xiaomi S20+ (xiaomi_miot only)

```yaml
type: custom:xiaomi-s20plus-vacuum-card
entity: vacuum.your_vacuum_entity
```

The card auto-discovers all helper entities (mode, suction, water selects) from the same device.

### Full config — Xiaomi Robot Vacuum 5 Pro (xiaomi_cloud_map_extractor)

```yaml
type: custom:xiaomi-s20plus-vacuum-card
entity: vacuum.your_vacuum_entity
map_source:
  camera_entity: camera.your_vacuum_live_map   # from xiaomi_cloud_map_extractor
fan_select: select.your_vacuum_mode            # suction level entity
show_battery: true
show_status: true
rooms:                                         # optional: filter/reorder rooms
  - Living
  - Cocina
  - Patio
```

> **Note for 5 Pro users:** the suction level entity is usually named `select.<vacuum>_mode`
> (options: Silent / Basic / Strong / Full Speed). Set it via `fan_select:` since the auto-discovery
> looks for `_suction_level` suffix which this model doesn't use.

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

- Only works with the `xiaomi_miot` integration (and optionally `xiaomi_cloud_map_extractor`)
- Room names come from your vacuum's built-in room map (set up via the Mi Home app)
- Tested on Xiaomi S20+ (B108GL) and Xiaomi Robot Vacuum 5 Pro (OV21GL)

---

## Troubleshooting

### Rooms not showing up?
Rooms are only pulled if they have been renamed in the Xiaomi Home app. Default names (Room 1, Room 2...) are not returned by the API.

### Suction section not visible on 5 Pro?
Add `fan_select: select.<your_vacuum>_mode` to your card config — the 5 Pro exposes suction as `_mode` not `_suction_level`.

### Water tank warnings not showing?
The chips appear automatically when `vacuum.water_tank_status = 1` (clean water empty) or `vacuum.sewage_tank_status = 1` (dirty water full) are detected in the vacuum entity attributes.

---

## License

MIT — see [LICENSE](LICENSE)
