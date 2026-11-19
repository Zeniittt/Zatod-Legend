using System;
using System.Linq;
using UnityEngine;
using Zatod.Heroes;
public static class VerifyCrystalData
{
    public static object Run()
    {
        var catalog=HeroDataJson.LoadBundledCatalog();
        var text=UnityEngine.Resources.Load<UnityEngine.TextAsset>("Data/CrystalCampaigns");
        var campaign=new CampaignCatalog(UnityEngine.JsonUtility.FromJson<CampaignDefinition>(text.text),catalog);
        var data=catalog.CreateHero("crystal_3","unity-crystal-lina");data.Level=40;
        var account=new CharacterData{CharacterId="unity-test"};account.HeroDesk.Add(data);
        var inventory=new ItemInventory(account,catalog);
        while(data.RankId!="blue")
        {
            foreach(var slot in HeroProgression.CurrentRank(data,catalog).EquipmentSlots)
            {
                var item=inventory.AddItemByItemId(slot.RequiredItemId)[0];inventory.Equip(data.HeroInstanceId,slot.Id,item.Id);
            }
            inventory.Promote(data.HeroInstanceId);
        }
        foreach(var slot in HeroProgression.CurrentRank(data,catalog).EquipmentSlots)
        {
            var item=inventory.AddItemByItemId(slot.RequiredItemId)[0];inventory.Equip(data.HeroInstanceId,slot.Id,item.Id);
        }
        inventory.Validate();
        if(data.AbsorbedItems.Count!=18 || data.EquippedItems.Count!=6 || campaign.Data.Chapters[0].Stages.Sum(s=>s.Waves.Count)!=54)throw new Exception("Crystal data coverage/progression failed");
        var json=HeroDataJson.WriteCharacter(account,catalog);var loaded=HeroDataJson.ReadCharacter(json,catalog);new ItemInventory(loaded,catalog).Validate();
        return new {status="PASS",heroes=catalog.Data.Heroes.Count(h=>h.SourceUnitId>0),monsters=catalog.Data.Monsters.Count(m=>m.SourceUnitId>0),waves=54,gear=data.EquippedItems.Count,absorbed=data.AbsorbedItems.Count,stats=HeroStatCalculator.Calculate(data,catalog).PreciseStats};
    }
}
return VerifyCrystalData.Run();
