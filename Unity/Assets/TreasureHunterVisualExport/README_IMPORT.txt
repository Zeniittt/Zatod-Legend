TREASURE HUNTER - VISUAL ASSET EXPORT

Import: Assets > Import Package > Custom Package, then choose TreasureHunter_VisualAssets.unitypackage. Start with Assets/TreasureHunterVisualExport. Source project: Unity 6000.6.2f1, URP 17.6.0. Materials retain their source shaders; use a compatible renderer/pipeline. This package does not change your project settings or install UPM packages.

CONTENTS
- Characters/Unit and Unit Basic 2/3: three original-rig visual presets with basic body, eyes, hair, helmet, clothes, boots, back and weapon art. Sprite sheets retain their original slice/pivot metadata.
- Environment: Grass/Undead/White backgrounds and the original shared environment sprite sheets. The exported backgrounds already contain the default zone colors. There is no map-generation code.
- Buildings: clan buildings, Viking/world structures, level art, animation/controllers and supporting graphics. Levels are assets; automatic level switching is not included.
- NPC: ordinary/event NPCs plus visual variants, including necessary nested SPUM-derived art. No standalone SPUM editor or full SPUM package is included.

VISUAL PREFABS
The exported prefabs are detached visual copies. Gameplay MonoBehaviours, physics and network/UI wrappers are excluded. Renderer sorting orders are retained, but tags, layers and sorting layers use Unity defaults for portability. Put them on your own sorting layers as needed. Animation hierarchies and original rig names are retained. Play animation states through the Animator; MMO locomotion, trading, equipment state and building level logic are not part of the visual prefabs.

ORIGINAL SOURCE ZIP
OriginalEquipmentScripts.zip is supplied next to the package and also inside it. It contains unchanged .cs sources, their .meta files and the original Unit.prefab for reference. Keep it zipped until you port the needed logic. Extracting the entire ZIP into a clean project Assets folder will require the original Mirror/game data/managers/UI dependencies. This is a focused source reference, not the entire MMO implementation or a standalone equipment system.

Appearance path: CharacterVisual -> PlayerBody/CharacterBody -> CharacterBodySprites -> CharacterCopySprite. CharacterBodySprites loads sheets from Resources/Icons/Items by EquipmentType and Card.GetName(0), using the original sprite-array order. Retain slot order and enum numeric values when adapting it. UnitSpriteBindings.json describes the visual renderer paths. No game server connection is needed to import or view these visual prefabs.

Some original animation clips may contain gameplay event names; this export does not implement those gameplay callbacks. Consult the source-reference ZIP when adapting animation/equipment behavior.

PROVENANCE
Only referenced SPUM-derived art is included. Original SPUM/addon README files are preserved with the art. Source asset paths and GUIDs are retained for textures, animations, materials and shaders; exported visual prefab GUIDs are new. Shared environment sheets may contain additional neighboring sprites. Do not replace existing same-GUID assets in another project without reviewing the import list.

See manifest/dependency/verification reports beside the package for the exact delivered inventory and checks. Verification distinguishes native prefab/reference checks from import/render tests; no gameplay/network behavior is claimed.

SOURCE OBSERVATION: Eight dangling sprite references were already missing in source visuals (Event Tournament, Obnit, and Merchandise variants). They were cleared only on exported copies, preserving their current rendered appearance; no replacement art was invented.
