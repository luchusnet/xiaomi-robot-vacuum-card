# Xiaomi Robot Vacuum S20+ Card

A custom Lovelace card for Home Assistant that gives you full room-by-room control of your Xiaomi Robot Vacuum S20+ using the [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) integration.

---

## Features

- **Room selection** — tap individual rooms or use All / Clear; rooms are read directly from the vacuum's room map
- **Mode control** — Vacuuming, Mopping, Vacuuming & Mopping, Vacuuming before mopping
- **Suction level** — Silent, Standard, Strong, Turbo
- **Water output** — Off, Level 1, Level 2, Level 3
- **Visual editor** — configure via the HA card editor, no YAML required
- **Auto entity discovery** — finds mode/suction/water select entities automatically via device registry; no manual entity IDs needed
- **LAN & Cloud mode support** — works in both Cloud mode and LAN mode; note that in LAN mode without internet, battery percentage and status chip are unavailable (all cleaning commands still work)

---

## Supported Hardware

Designed for the **Xiaomi Robot Vacuum S20+** (model B108GL) via the `xiaomi_miot` integration.

May work on other Xiaomi MiOT vacuum models that expose room info via the `vacuum_extend.room_info` attribute, but only the S20+ has been tested.

**Does not work with:** Valetudo, Roborock, Dreame, or any other integration — this card calls `xiaomi_miot` services directly.

---

## Requirements

- Home Assistant (any recent version)
- [xiaomi_miot](https://github.com/al-one/hass-xiaomi-miot) custom integration (installable via HACS)
- Your vacuum set up in xiaomi_miot with room mapping configured

---

## Installation

### Via HACS (recommended)

1. In HACS, go to **Frontend** → click the **+** button
2. Search for **Xiaomi Robot Vacuum S20+ Card**
3. Click **Download**

After installation, add the card to your dashboard.

### Manual

1. Download `xiaomi-s20plus-vacuum-card.js` from the [latest release](https://github.com/tojolab/xiaomi-s20plus-vacuum-card/releases/latest)
2. Copy it to `/config/www/xiaomi-s20plus-vacuum-card.js` on your HA server
3. In HA → Settings → Dashboards → Resources, add:
   - URL: `/local/xiaomi-s20plus-vacuum-card.js`
   - Type: JavaScript module
4. Hard-refresh your browser (Ctrl+Shift+R)

---

## Configuration

### Minimal (recommended)

```yaml
type: custom:xiaomi-s20plus-vacuum-card
entity: vacuum.your_vacuum_entity
```

The card auto-discovers all helper entities (mode, suction, water selects) from the same device.


---

## Known Limitations

- Only works with the `xiaomi_miot` integration
- Room names in the card come from your vacuum's built-in room map (set up via the Mi Home app); they must match what the integration exposes
- Tested on Xiaomi S20+ (B108GL) only — other models may or may not work

---
