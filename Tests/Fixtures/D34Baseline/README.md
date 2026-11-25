# D34 compatibility and import baseline

Snapshot of the 25-Hero/two-chapter Data immediately before D34 activation. These are catalog definitions, not an account or player save. `manifest.json` records SHA-256 for all 14 text files. Keep this fixture immutable: it anchors existing V3–V6, migration/transaction tests and source import after the bundled runtime grows to 66 Hero definitions.

The D34 builder and Hero importer use this baseline by default. Native acceptance and farm commands take the expanded Data explicitly; farm CLI defaults still target bundled runtime Data. The source reference remains `Unity/Assets/Crystal Legend/` and alias compatibility remains governed by `ZatodContentIds.cs`.
