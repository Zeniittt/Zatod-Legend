TREASURE HUNTER JOYSTICK EXPORT

Import TreasureHunter_Joystick.unitypackage through Assets > Import Package > Custom Package.
Open Assets/TreasureHunterJoystickExport/GameSkin for the game-style Fixed, Floating, Dynamic and legacy Floating variants. PackDefaults contains the four pack styles (Fixed/Floating/Dynamic/Variable). All pack sprites, game joystick art, setting/HUD icons, two custom inspectors and the original package PDF are included.

SETUP
1. Place one joystick prefab under a Canvas with a GraphicRaycaster.
2. Ensure the scene has an EventSystem and the appropriate input module. For Unity's legacy input use StandaloneInputModule; with the new Input System configure InputSystemUIInputModule in your destination project.
3. Read Direction, Horizontal and Vertical from the Joystick component each frame. Supply the resulting intent to your own character controller. Importing the UI does not make Unit move by itself.
4. In VariableJoystick, select Fixed/Floating/Dynamic in the Inspector. GameSkin presets already have the matching mode. Review RectTransform anchors/sizes for your screen and CanvasScaler.

PORTABILITY
Original FloatingJoystick and DynamicJoystick call the MMO UIManager and perform Camera.main / Physics2D blocking checks. Their exported portable prefab copies use the existing unchanged VariableJoystick implementation instead, with common serialized fields and background/handle bindings preserved. The MMO-specific world/UI physics-blocking filter is not part of these portable copies; add your destination game's own UI gating as needed. The original prefabs/scripts remain in OriginalJoystickSource.zip beside this package and inside the imported folder.

Three runtime scripts are imported unchanged: Joystick.cs, FixedJoystick.cs, VariableJoystick.cs. Two Editor inspectors are imported unchanged. They use Unity/uGUI, with no Mirror, UIManager or game login dependency. Original class names and GUIDs are retained; review conflicts if you already have Joystick Pack installed.

SOURCE OBSERVATION
The original Joystick.AxisOptions getter calls itself recursively. This export preserves source bytes; configure Axis Options through the Inspector/serialized field rather than reading that getter in custom code. No third-party bug fix was made.

The ZIP contains the complete original Joystick Pack plus game skins and UIManager, SettingView, ViewSessionInputGate, AuthorativePlayerMovement and PlayerBehaviorMovement integration references. Keep it zipped unless you intend to port the original game integration.

Verification: native prefab binding and pointer drag/clamp/release checks plus archive/source/checksum verification. Source project Unity 6000.6.2f1, uGUI 2.6.0. No separate clean-project import or Player build is claimed. The prior character/world export is separate and unchanged.
