# PDV_TOOLS 005

Standalone candidate for the point-of-view tools.

## Entrypoint

Use:

```maxscript
fileIn @"D:\MaxscriptIA\Maxscript\PDV_TOOLS\005\pdv_tools_launcher.ms"
```

Legacy compatibility entrypoint:

```maxscript
fileIn @"D:\MaxscriptIA\Maxscript\PDV_TOOLS\005\pdv_tools_float.ms"
```

`pdv_tools_float.ms` only redirects to `pdv_tools_launcher.ms`.

## Files

- `pdv_tools_launcher.ms`: standalone loader and rollout floater creation.
- `pdv_tools.ms`: camera / point-of-view UI.
- `place_suns.ms`: sun placement UI.
- `captureCams.ms`: camera-name capture helper.
- `rollout_pref.ms`: standalone preference helper adapted from `Maxscript/rollout_pref/rollout_pref.ms`.

## Preferences

This tool uses prefixed preference functions:

```maxscript
PDV_loadRolloutParams rollout params
PDV_writeRolloutParams rollout params
```

Preferences are stored per user and per machine here:

```maxscript
(GetDir #maxData) + "VisiolabTools\\PDV_TOOLS\\prefs.ini"
```

The pref helper is prefixed to avoid overwriting the legacy global `loadRolloutParams` / `writeRolloutParams` helpers.

## Migration Notes

This folder should be tested as a standalone unit before replacing older `PDV_TOOLS` versions.

