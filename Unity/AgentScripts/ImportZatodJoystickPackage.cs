using System.IO;
using UnityEditor;
string source=Path.GetFullPath("../TreasureHunter_Joystick_Export_2026-11-20/TreasureHunter_Joystick.unitypackage");
AssetDatabase.ImportPackage(source,false);
return new{Package=source,Interactive=false};
