using System.IO;
using UnityEngine;
namespace Zatod.Heroes
{
    public static class ProgressionDataJson
    {
        public const string AssetPath="Assets/Zatod/Resources/Data/Progression.txt";
        static ProgressionCatalog bundled;
        public static ProgressionCatalog LoadBundled()
        {if(bundled!=null)return bundled;var asset=Resources.Load<TextAsset>("Data/Progression");if(asset==null)throw new FileNotFoundException(AssetPath);return bundled=new ProgressionCatalog(JsonUtility.FromJson<ProgressionDefinition>(asset.text));}
        public static void ResetCache()=>bundled=null;
    }
}
