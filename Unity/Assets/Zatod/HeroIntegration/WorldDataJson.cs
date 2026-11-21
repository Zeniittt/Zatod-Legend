using System.IO;
using UnityEngine;
using Zatod.Heroes;
namespace Zatod.World
{
    public static class WorldDataJson
    {
        public static WorldCatalog Load(CampaignCatalog campaign)
        {
            var text=Resources.Load<TextAsset>("Data/Worlds");if(text==null)throw new FileNotFoundException("Zatod world config is missing.");
            return new WorldCatalog(JsonUtility.FromJson<WorldDefinition>(text.text),campaign,resource=>
            {
                var island=Resources.Load<TextAsset>(resource);if(island==null)throw new FileNotFoundException("Missing island config: "+resource);
                return JsonUtility.FromJson<WorldMapDefinition>(island.text);
            });
        }
    }
}
