# flutter_flow/ — Hand-Maintained (FlutterFlow Ejected)

**Do NOT regenerate these files from FlutterFlow.**

## Status

This project was migrated away from FlutterFlow on 2026-01-10 (commit `0a0419a`). The
`flutter_flow/` directory contains the original generated widget library retained from the
habu predecessor app. All files in this directory are now hand-maintained and treated as
regular source code.

## Why this matters

`font_awesome_flutter` 11.x (required by Flutter 3.27+) introduced a distinct `FaIconData`
type because `IconData` became `final` in Flutter 3.27. The following files were patched in
PR #7 (commit `75e1668`, 2026-06-14) to make the 10 affected call sites type-safe:

| File | Change |
|------|--------|
| `flutter_flow_icon_button.dart` | Wrap `IconData` → `FaIconData(...)` for `FaIcon` slot |
| `flutter_flow_widgets.dart` | Wrap `IconData` → `FaIconData(...)` for `FaIcon` slot |
| `flutter_flow_choice_chips.dart` | Wrap `IconData` → `FaIconData(...)` for `FaIcon` slot |
| `../search/search_widget.dart` | Unwrap `FontAwesomeIcons.X` → `.data` for `IconData` slots (7 sites) |

A FlutterFlow re-export would clobber these patches and break CI immediately because the
generated code still uses the pre-11.x `FaIcon(icon.icon)` pattern. **Don't re-export.**

## If you need to add FlutterFlow features

Re-integrate by copying only the new widget definitions from a FlutterFlow export, then
manually apply the `FaIconData` wrapping pattern above to any new `FaIcon` call sites.
Search for `FaIcon(` in any imported file and verify each `icon:` argument is typed as
`FaIconData`, not bare `IconData`.
