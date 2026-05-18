# MaxScript Coding Rules

## Tool Organization

Work tool by tool. Do not reorganize the whole repository at once.

Each standalone tool should live in one folder with its own entrypoint, UI scripts, helper scripts, icons, config, and local documentation.

Prefer this structure:

```text
tool_name/
  tool_name.ms
  rollout_pref.ms
  lib/
  ui/
  icons/
  config/
  README.md
```

## Preferences

Use the existing rollout preference helper as the reference implementation:

```text
rollout_pref/rollout_pref.ms
```

Main functions:

```maxscript
loadRolloutParams rollout params
writeRolloutParams rollout params
```

For standalone tools, copy or adapt this helper into the tool folder instead of depending on a shared global library.

Do not invent a new preference system unless explicitly requested.

Store preferences per user and per machine under `GetDir #maxData`, not in the shared network tool folder.

Recommended standalone preference location:

```maxscript
(GetDir #maxData) + "VisiolabTools\\tool_name\\prefs.ini"
```

## Roots And Paths

Avoid hardcoded absolute paths inside tools when possible.

Each standalone tool should resolve paths from its own tool root or from user/studio config.

Existing global `getRoot()` is acceptable for legacy tools, but standalone tools should not require the whole shared script tree to be installed.

## Compatibility

Do not move active scripts without checking `filein`, macroscript, startup, and launcher dependencies first.

When migrating an existing tool, keep a temporary wrapper or legacy entrypoint if old paths may still be used by toolbars or macros.

## Error Handling

Avoid silent `try(...)catch()` blocks in new or refactored code.

At minimum, log the exception:

```maxscript
catch(format "ERROR: %\n" (getCurrentException()))
```

## Globals

Minimize global variables. Use globals only for rollouts, macroscript-facing entrypoints, or compatibility with existing MaxScript UI behavior.

Prefer tool-prefixed names for globals, for example `PDVTOOLS_ROOT` instead of `root`.
