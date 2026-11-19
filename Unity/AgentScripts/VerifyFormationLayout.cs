using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyFormationLayout
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);
        var account=campaign.CreateDemoCharacter(heroes);var ids=account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();
        var setup=CampaignBattleFactory.Prepare(campaign,heroes,account,"chapter_1_stage_1",ids);
        Check(setup.Fighters.All(f=>f.formationSpacing==(f.team==0?850:650) && !f.flexibleFormationSpacing),"Original friendly walking spacing/order");
        Check(setup.Fighters.Where(f=>f.team==0).Select(f=>f.y).Distinct().Count()==2,"Original shallow alternating depths not restored");
        foreach(var f in setup.Fighters)Check(f.y==(f.slot%2==0?120:-140),"Matching shallow depth pattern changed");
        var record=setup.Run(Guid.NewGuid().ToString("N"),55);Check(record.winner==0,"Could not clear first encounter");
        var timeline=new ReplayTimeline(record);long minimumMelee=long.MaxValue;
        for(int tick=0;tick<=record.durationTicks;tick+=10)
        {
            timeline.Seek(tick);
            foreach(int team in new[]{0,1})
            {
                var line=timeline.States.Values.Where(f=>f.team==team && f.Alive).OrderBy(f=>f.slot).ToArray();
                for(int i=1;i<line.Length;i++)Check(team==0?line[i-1].x>=line[i].x:line[i-1].x<=line[i].x,"Friendly front-to-back order changed");
            }
        }
        foreach(var e in record.events.Where(e=>e.kind==BattleEventKind.Action && e.hasState && e.state.action==BattleAction.Attack))
        {
            timeline.Seek(e.tick);var a=timeline.States[e.actorId];
            if(a.range!=1300 || !timeline.States.TryGetValue(a.actionTargetId,out var target))continue;
            long gap=CombatGeometry.CenterDistance(a,target);minimumMelee=Math.Min(minimumMelee,gap);
            Check(gap>=1220,"Melee still walking inside the opponent center");
        }
        Check(minimumMelee!=long.MaxValue,"No normal melee actions");
        var textures=new Dictionary<string,Texture2D>();
        bool OpaqueAt(ReplaySprite visual,Vector2 world)
        {
            var sprite=visual.GetComponent<UnityEngine.UI.Image>().sprite;var rect=(RectTransform)visual.transform;var local=rect.InverseTransformPoint(world);
            if(!rect.rect.Contains(local))return false;
            int x=Mathf.FloorToInt(sprite.rect.xMin+(local.x-rect.rect.xMin)/rect.rect.width*sprite.rect.width);
            int y=Mathf.FloorToInt(sprite.rect.yMin+(local.y-rect.rect.yMin)/rect.rect.height*sprite.rect.height);
            return textures[AssetDatabase.GetAssetPath(sprite)].GetPixel(x,y).a>32/255f;
        }
        Rect Body(ReplaySprite visual)
        {
            var image=visual.GetComponent<UnityEngine.UI.Image>();var sprite=image.sprite;string path=AssetDatabase.GetAssetPath(sprite);
            if(!textures.TryGetValue(path,out var texture)){texture=new Texture2D(2,2);texture.LoadImage(File.ReadAllBytes(path));textures.Add(path,texture);}
            var colors=texture.GetPixels32();var crop=sprite.rect;int left=int.MaxValue,right=-1,bottom=int.MaxValue,top=-1;
            for(int y=(int)crop.yMin;y<(int)crop.yMax;y++)for(int x=(int)crop.xMin;x<(int)crop.xMax;x++)
                if(colors[y*texture.width+x].a>32){left=Math.Min(left,x);right=Math.Max(right,x);bottom=Math.Min(bottom,y);top=Math.Max(top,y);}
            Check(right>=left,"Empty body "+visual.transform.parent.name);var rect=(RectTransform)visual.transform;
            Vector3 Point(float x,float y)=>rect.TransformPoint(new Vector3(rect.rect.xMin+(x-crop.xMin)*rect.rect.width/crop.width,rect.rect.yMin+(y-crop.yMin)*rect.rect.height/crop.height));
            var a=Point(left,bottom);var b=Point(right+1,top+1);return Rect.MinMaxRect(Math.Min(a.x,b.x),Math.Min(a.y,b.y),Math.Max(a.x,b.x),Math.Max(a.y,b.y));
        }
        async Task<(float visible,float friendly,Rect[] bodies)> Inspect(BattleRecord battle)
        {
            arena.GetComponent<CampaignView>()?.Hide();arena.Load(battle);arena.SetVisible(true);if(arena.Playing)arena.TogglePlayback();arena.Seek(2.1f);
            await Task.Delay(80);Canvas.ForceUpdateCanvases();
            var sprites=UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude).Where(s=>s.name=="HeroSprite").OrderBy(s=>s.transform.parent.GetSiblingIndex()).ToArray();
            Check(sprites.Length==10,"Expected ten visible body sprites");var bounds=sprites.Select(Body).ToArray();int leenald=Array.FindIndex(sprites,s=>s.transform.parent.name=="Fighter_1");
            var body=bounds[leenald];int uncovered=0,total=0;
            for(int y=0;y<40;y++)for(int x=0;x<40;x++)
            {var p=new Vector2(body.xMin+(x+.5f)*body.width/40,body.yMin+(y+.5f)*body.height/40);if(!OpaqueAt(sprites[leenald],p))continue;total++;if(!sprites.Skip(leenald+1).Any(s=>OpaqueAt(s,p)))uncovered++;}
            float friendly=0;
            for(int i=0;i<sprites.Length;i++)
            {
                int id=int.Parse(sprites[i].transform.parent.name.Substring(8)),team=battle.initial.Single(f=>f.id==id).team,visiblePixels=0,bodyPixels=0;
                for(int y=0;y<20;y++)for(int x=0;x<20;x++)
                {
                    var p=new Vector2(bounds[i].xMin+(x+.5f)*bounds[i].width/20,bounds[i].yMin+(y+.5f)*bounds[i].height/20);
                    if(!OpaqueAt(sprites[i],p))continue;bodyPixels++;
                    if(!sprites.Skip(i+1).Any(s=>battle.initial.Single(f=>f.id==int.Parse(s.transform.parent.name.Substring(8))).team==team && OpaqueAt(s,p)))visiblePixels++;
                }
                friendly+=(float)visiblePixels/Math.Max(1,bodyPixels);
            }
            return((float)uncovered/total,friendly/sprites.Length,bounds);
        }
        var old=ReplayArchive.Decode(File.ReadAllBytes("../Artifacts/CampaignUi/76a61ca2486c41d280e7fdd0de5143d5/Replays/105b35e53f8a4b12ad286b7b7852439a.arena.gz"));
        Check(old.formationLayoutVersion==0,"Old archive unexpectedly changed");var before=await Inspect(old);var after=await Inspect(record);
        Check(after.visible>before.visible,"Leenald less readable than original layout: before="+before.visible+" after="+after.visible);
        Check(after.friendly>before.friendly,"Friendly teams remain as crowded as before");
        var actorLayer=UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Exclude).Single(t=>t.name=="Fighter_1").parent as RectTransform;
        var corners=new Vector3[4];actorLayer.GetWorldCorners(corners);var field=Rect.MinMaxRect(corners[0].x,corners[0].y,corners[2].x,corners[2].y);
        foreach(var r in after.bodies)Check(field.Contains(r.min) && field.Contains(r.max),"Body outside battlefield: "+r+" field="+field);
        // A projectile and its actor use the same depth, height and camera-size mapping.
        var p=record.projectiles.First(p=>p.actorId==3 && p.endTick>p.startTick+1);arena.Seek(p.startTick/20f);await Task.Delay(40);Canvas.ForceUpdateCanvases();
        var source=UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude).Single(s=>s.name=="HeroSprite" && s.transform.parent.name=="Fighter_3");
        var shot=UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude).First(s=>s.name=="Projectile_3");
        float artScale=((RectTransform)source.transform).rect.width/source.GetComponent<UnityEngine.UI.Image>().sprite.rect.width*.25f;
        float height=((RectTransform)shot.transform).anchoredPosition.y-(record.initial.Single(f=>f.id==3).y*.2f-45);
        Check(Mathf.Abs(height-p.spawnHeight*artScale)<.2f,"Projectile muzzle height drifted from scaled body");
        var archive=ReplayArchive.Decode(ReplayArchive.Encode(record));Check(archive.formationLayoutVersion==3,"Layout version not archived");
        Directory.CreateDirectory("../Artifacts/FormationLayoutChecks");File.WriteAllBytes("../Artifacts/FormationLayoutChecks/stage1.arena.gz",ReplayArchive.Encode(record));
        var evidence=new{passed=true,checks,minimumMelee,leenaldVisibleBefore=before.visible,leenaldVisibleAfter=after.visible,friendlyVisibleBefore=before.friendly,friendlyVisibleAfter=after.friendly,rules=record.rulesVersion};
        File.WriteAllText("../Artifacts/FormationLayoutChecks/result.json",Newtonsoft.Json.JsonConvert.SerializeObject(evidence,Newtonsoft.Json.Formatting.Indented));
        foreach(var texture in textures.Values)UnityEngine.Object.DestroyImmediate(texture);
        arena.Seek(2.1f);return evidence;
    }
}
