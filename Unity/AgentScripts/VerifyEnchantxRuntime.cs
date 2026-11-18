using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyEnchantxRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();var manifest=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(catalog.Hero("enchantx").AnimationSetResource).text);
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();var root=window.rootVisualElement;
        var heroes=root.Q<DropdownField>("sandbox-hero");heroes.value=heroes.choices.Single(s=>s.EndsWith("(enchantx)"));
        Check(root.Q<IntegerField>("sandbox-distance").value==1410,"Opening motion test distance not selected");
        root.Q<IntegerField>("sandbox-duration").value=25;root.Q<IntegerField>("sandbox-target-count").value=3;
        root.Q<IntegerField>("sandbox-casts").value=1;
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        string owned=JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character);
        ReplaySprite[] Sprites(){return UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Include);}
        async Task Click(string name)
        {
            string previous=arena.Record?.battleId;var button=root.Q<UnityEngine.UIElements.Button>(name);
            Check(button!=null && button.enabledInHierarchy,"Missing/locked button: "+name);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
            var until=DateTime.UtcNow.AddSeconds(10);
            while((arena.Record==null || arena.Record.battleId==previous) && DateTime.UtcNow<until)await Task.Delay(25);
            Check(arena.Record!=null && arena.Record.battleId!=previous && arena.Record.initial[0].heroDefinitionId=="enchantx","Button did not load Enchantx");
            if(arena.Playing)arena.TogglePlayback();await Task.Delay(60);
        }
        void Drawn(ReplaySprite sprite,string reason)
        {
            Canvas.ForceUpdateCanvases();var image=sprite.GetComponent<UnityEngine.UI.Image>();
            Check(sprite.gameObject.activeInHierarchy && image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,reason);
            var stage=GameObject.Find("BattleStage").GetComponent<RectTransform>();
            var bounds=RectTransformUtility.CalculateRelativeRectTransformBounds(stage,sprite.transform);
            Check(bounds.max.y<=stage.rect.yMax+2 && bounds.min.y>=stage.rect.yMin-2,"Effect/body outside vertical battlefield: "+sprite.name);
        }
        Check(Resources.Load<Sprite>("HeroPortraits/enchantx")!=null,"Cropped portrait not loadable");
        await Click("sandbox-basic");
        var normal=arena.Record.events.First(e=>e.kind==BattleEventKind.Action && e.ability==catalog.Skill("enchantx_normal_attack").Name);
        var body=Sprites().Single(s=>s.transform.parent.name=="Fighter_1");var clip=manifest.Clips.Single(c=>c.State=="NormalAttack");
        for(int i=0;i<clip.FrameTimes.Count;i++)
        {
            arena.Seek(normal.tick/20f+clip.FrameTimes[i]+.002f);
            Check(body.CurrentState=="NormalAttack" && body.GetComponent<UnityEngine.UI.Image>().sprite.name==System.IO.Path.GetFileNameWithoutExtension(clip.SourceFrames[i]),"Variable key duration/order not respected");
        }
        await Click("sandbox-cast-ultimate");
        var beam=arena.Record.visualEffects.Single(v=>v.state=="StormArrow");
        var beamSprite=Sprites().Single(s=>s.name.StartsWith("FX_StormArrow_"));
        arena.Seek((beam.startTick+1)/20f);Drawn(beamSprite,"Wind arrow missing");float origin=beamSprite.GetComponent<RectTransform>().anchoredPosition.x;
        arena.Seek((beam.startTick+5)/20f);Drawn(beamSprite,"Wind arrow later frame missing");
        Check(Mathf.Abs(origin-beamSprite.GetComponent<RectTransform>().anchoredPosition.x)<.001f,"Wind-ring origin slid horizontally");
        var tornado=arena.Record.visualEffects.Single(v=>v.state=="WindStorm_Triggered");
        arena.Seek((tornado.startTick+1)/20f);Drawn(Sprites().Single(s=>s.name.StartsWith("FX_WindStorm_Triggered_")),"Target tornado missing");
        await Click("sandbox-cast-skill_2");
        var rain=arena.Record.visualEffects.Single(v=>v.state=="Rain_Triggered");
        arena.Seek((rain.startTick+4)/20f);var rainSprite=Sprites().Single(s=>s.name.StartsWith("FX_Rain_Triggered_"));Drawn(rainSprite,"Rain missing");
        var target=GameObject.Find("Fighter_"+rain.targetId).GetComponent<RectTransform>();
        Check(Mathf.Abs(rainSprite.transform.position.x-target.position.x)<.01f,"Rain is not centered on locked target location");
        await Click("sandbox-cast-skill_4");
        Check(arena.Record.projectiles.Count==3,"Triple shot has wrong projectile count");
        foreach(var projectile in arena.Record.projectiles)
        {
            arena.Seek((projectile.startTick+1)/20f);
            Check(Sprites().Any(s=>s.name=="Projectile_1" && s.gameObject.activeInHierarchy && s.CurrentState=="Arrow_Shot"),"Released arrow not visible");
        }
        await Click("sandbox-test-all");
        foreach(var slot in catalog.Hero("enchantx").SkillSlots)
            Check(arena.Record.events.Any(e=>e.kind==BattleEventKind.Action && e.ability==catalog.Skill(slot.SkillId).Name),"Test-all did not cast "+slot.Id);
        await Click("sandbox-test-all");
        foreach(var slot in catalog.Hero("enchantx").SkillSlots)
            Check(arena.Record.events.Any(e=>e.kind==BattleEventKind.Action && e.ability==catalog.Skill(slot.SkillId).Name),"Test-all did not cast "+slot.Id);
        root.Q<IntegerField>("sandbox-casts").value=2;
        await Click("sandbox-cast-skill_3");
        var r=arena.Record;body=Sprites().Single(s=>s.transform.parent.name=="Fighter_1");
        arena.Seek(.55f);Drawn(body,"Opening jump body missing");
        Check(body.CurrentState=="Skill3" && arena.Timeline.States[1].presentationHeight>0,"Opening jump absent");
        var phases=r.visualEffects.Where(v=>v.state.StartsWith("FlameWings_")).ToArray();
        foreach(var phase in phases)
        {
            arena.Seek((phase.startTick+2)/20f);
            var visual=Sprites().Single(s=>s.name.StartsWith("FX_"+phase.state+"_") && s.gameObject.activeInHierarchy);
            Drawn(visual,"FlameWings phase missing: "+phase.state);
            float sample=visual.SampleSeconds;var position=visual.transform.position;await Task.Delay(40);
            Check(visual.SampleSeconds==sample && visual.transform.position==position,"Paused bird moved/animated");
        }
        var repeat=r.events.First(e=>e.kind==BattleEventKind.Action && e.state.animationState=="Skill3Repeat");
        arena.Seek(repeat.tick/20f);float stationary=GameObject.Find("Fighter_1").transform.position.x;
        arena.Seek((repeat.tick+10)/20f);
        Check(body.CurrentState=="Skill3Repeat" && Mathf.Abs(GameObject.Find("Fighter_1").transform.position.x-stationary)<.001f && arena.Timeline.States[1].presentationHeight==0,"Repeat used entry motion");
        var burst=r.visualEffects.First(v=>v.shockwave);
        arena.Seek((burst.startTick+4)/20f);Canvas.ForceUpdateCanvases();
        var ring=UnityEngine.Object.FindObjectsByType<ArenaGraphic>().Single(g=>g.name=="BurstRing_"+burst.startTick);
        Check(ring.canvasRenderer.GetMesh().vertexCount>0 && !ring.canvasRenderer.cull,"Buff explosion ring missing");
        Check(arena.Timeline.States[1].damageBonusBasisPoints==2000,"Buff not reflected in replay state");
        arena.Seek((burst.startTick-1)/20f);Check(!ring.gameObject.activeSelf,"Burst shown before buff");
        arena.Seek((burst.startTick+4)/20f);Check(ring.gameObject.activeSelf,"Backward seek did not restore burst");
        var expiration=r.events.Last(e=>e.kind==BattleEventKind.Buff).tick;
        arena.Seek(expiration/20f);Check(arena.Timeline.States[1].damageBonusBasisPoints==0,"Replay buff did not expire");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox started networking");
        Check(JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character)==owned,"Sandbox mutated owned HeroDesk");
        arena.Seek(12.7f);
        return new{passed=true,checks,hero="Enchantx",openingAndRepeat=true,pausedAt=arena.Playhead};
    }
}
