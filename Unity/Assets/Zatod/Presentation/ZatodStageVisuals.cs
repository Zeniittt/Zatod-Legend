using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Presentation
{
    public static class ZatodStageVisuals
    {
        public const string IconPath = "Zatod/World/StageIcons/";

        public static Sprite Icon(CampaignStageDefinition stage, bool unlocked = true)
        {
            string suffix = unlocked ? "" : "_locked";
            return Resources.Load<Sprite>(IconPath + "stage_" + stage.SourceStageId + suffix)
                ?? Resources.Load<Sprite>(IconPath + "stage_node" + suffix);
        }

        public static string SourceLabel(int chapterNumber, CampaignStageDefinition stage)
            => (stage.Difficulty == 2 ? "Elite" : "Normal") + " · Ch." + chapterNumber + " · " + stage.Name;
    }
}
