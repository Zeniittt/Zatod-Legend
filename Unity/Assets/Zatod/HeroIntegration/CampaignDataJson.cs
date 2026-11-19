using System.IO;
using UnityEngine;

namespace Zatod.Heroes
{
    public static class CampaignDataJson
    {
        public const string AssetPath="Assets/Zatod/Resources/Data/Campaigns.txt";
        public static CampaignCatalog LoadCrystal(HeroCatalog heroes)
        {
            var asset=Resources.Load<TextAsset>("Data/CrystalCampaigns");
            if(asset==null)throw new FileNotFoundException("Crystal campaign config is missing.");
            return new CampaignCatalog(JsonUtility.FromJson<CampaignDefinition>(asset.text),heroes);
        }
        public static CampaignCatalog Load(HeroCatalog heroes)
        {
            var asset=Resources.Load<TextAsset>("Data/Campaigns");if(asset==null)throw new FileNotFoundException("Campaign config is missing.");
            return new CampaignCatalog(JsonUtility.FromJson<CampaignDefinition>(asset.text),heroes);
        }
    }
}
