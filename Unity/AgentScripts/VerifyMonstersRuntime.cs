using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyMonstersRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var catalog=HeroDataJson.LoadBundledCatalog();string config=JsonUtility.ToJson(catalog.Data);
        foreach(var monster in catalog.Data.Monsters)
        {
            Check(monster.SkillIds.Count==0,"Starter monster has skills");
            Check(Resources.Load<GameObject>(monster.BodyPrefabResource)!=null && Resources.Load<Sprite>("MonsterPortraits/"+monster.PortraitKey)!=null,"Monster assets missing");
            var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(monster.AnimationSetResource).text);
            foreach(string state in new[]{"Idle","Run","NormalAttack","Stun","Death"})Check(set.Clips.Any(c=>c.State==state),"Missing monster state: "+state);
            foreach(var entry in set.Clips)
            {
                var keys=AnimationUtility.GetObjectReferenceCurve(Resources.Load<AnimationClip>(entry.ClipResource),EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
                Check(keys.Length==entry.SourceFrames.Count && entry.FrameTimes.Count==keys.Length,"Monster key count");
                for(int i=0;i<keys.Length;i++)Check(Mathf.Abs(keys[i].time-entry.FrameTimes[i])<.0001f && ((Sprite)keys[i].value).pixelsPerUnit==25,"Monster timing/PPU");
            }
        }
        HeroBalanceWindow.OpenMonsters();
        var balance=Resources.FindObjectsOfTypeAll<HeroBalanceWindow>().Single(w=>w.titleContent.text=="Monster Balance");
        var tab=balance.rootVisualElement.Query<UnityEngine.UIElements.Button>().ToList().Single(b=>b.text=="Monsters");
        using(var e=NavigationSubmitEvent.GetPooled()){e.target=tab;tab.SendEvent(e);}
        Check(balance.rootVisualElement.Q<TextField>("section-json-input").value.Contains("fighter_goblin"),"Monster balance tab missing data");
        var window=EditorWindow.GetWindow<HeroCombatSandboxWindow>();var root=window.rootVisualElement;
        var heroField=root.Q<DropdownField>("sandbox-hero");heroField.value=heroField.choices.Single(c=>c.EndsWith("(kavern)"));
        var rank=root.Q<DropdownField>("sandbox-rank");rank.value=rank.choices.Last();
        root.Q<IntegerField>("sandbox-duration").value=30;root.Q<IntegerField>("sandbox-hp").value=100;root.Q<IntegerField>("sandbox-target-hp").value=0;
        root.Q<IntegerField>("sandbox-casts").value=1;root.Q<IntegerField>("sandbox-distance").value=1200;root.Q<IntegerField>("sandbox-spacing").value=220;
        void Click(string name)
        {
            var button=root.Q<UnityEngine.UIElements.Button>(name);Check(button!=null && button.enabledInHierarchy,"Missing/disabled: "+name);
            using(var e=NavigationSubmitEvent.GetPooled()){e.target=button;button.SendEvent(e);}
        }
        void Pick(string field,string id)
        {var dropdown=root.Q<DropdownField>(field);dropdown.value=dropdown.choices.Single(c=>c.EndsWith("("+id+")"));}
        root.Q<IntegerField>("sandbox-target-count").value=1;Pick("sandbox-monster-0","fighter_goblin");
        Pick("sandbox-monster-choice","goblin_mage");Click("sandbox-add-monster");Click("sandbox-add-monster");
        Check(root.Q<IntegerField>("sandbox-target-count").value==3 && root.Q<DropdownField>("sandbox-monster-1").value.Contains("goblin_mage") && root.Q<DropdownField>("sandbox-monster-2").value.Contains("goblin_mage"),"Repeated monster selection failed");
        root.Q<IntegerField>("sandbox-target-count").value=5;
        Check(!root.Q<UnityEngine.UIElements.Button>("sandbox-add-monster").enabledInHierarchy,"Exceeded monster capacity");
        Click("sandbox-remove-monster-4");Check(root.Q<IntegerField>("sandbox-target-count").value==4,"Remove did not update count");
        root.Q<IntegerField>("sandbox-target-count").value=3;Pick("sandbox-monster-1","skeleton_knight");Pick("sandbox-monster-2","goblin_mage");
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        string owned=JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character);
        async Task RunButton(string name)
        {
            string previous=arena.Record?.battleId;Click(name);var until=DateTime.UtcNow.AddSeconds(15);
            while((arena.Record==null || arena.Record.battleId==previous) && DateTime.UtcNow<until)await Task.Delay(25);
            Check(arena.Record!=null && arena.Record.battleId!=previous && arena.SandboxMode,"Test did not open: "+root.Q<Label>("sandbox-status").text);
            if(arena.Playing)arena.TogglePlayback();await Task.Delay(70);
        }
        await RunButton("sandbox-basic");var record=arena.Record;
        Check(record.initial.Count(f=>f.team==0)==1 && record.initial.Count(f=>f.team==1)==3,"Sandbox changed Hero count or lost monsters");
        Check(record.loadouts.Count(l=>l.hero!=null)==1 && record.loadouts.Count(l=>l.monster!=null)==3,"Monster loadouts masquerade as Heroes");
        Check(record.events.Any(e=>e.kind==BattleEventKind.Move && e.actorId>=101) && record.events.Any(e=>e.kind==BattleEventKind.Damage && e.actorId>=101 && e.targetId==1),"Monsters did not chase and fight");
        Check(record.initial.Single(f=>f.monsterDefinitionId=="fighter_goblin").maxHp==900,"Config HP ignored");
        foreach(string state in new[]{"Run","NormalAttack","Death"})
        {
            var sample=record.events.FirstOrDefault(e=>e.targetId>=101 && (state=="Run"?e.kind==BattleEventKind.Move:state=="Death"?e.kind==BattleEventKind.Death:e.kind==BattleEventKind.Action && e.state.animationState=="NormalAttack"));
            Check(sample!=null,"No monster animation event: "+state);
            int id=sample.targetId;arena.Seek((sample.tick+1)/20f);Canvas.ForceUpdateCanvases();
            var sprite=UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(s=>s.transform.parent.name=="Fighter_"+id);
            var image=sprite.GetComponent<UnityEngine.UI.Image>();
            Check(sprite.CurrentState==state && image.enabled && image.sprite!=null && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount>=4,"Monster is not drawn in state "+state);
        }
        var fireball=record.projectiles.First(p=>p.actorId>=101 && p.endTick-p.startTick>1);
        arena.Seek((fireball.startTick+1)/20f);Canvas.ForceUpdateCanvases();
        var flight=UnityEngine.Object.FindObjectsByType<ReplaySprite>().First(s=>s.name=="Projectile_"+fireball.actorId && s.gameObject.activeInHierarchy);
        Check(flight.CurrentState=="Fireball_Triggered" && flight.GetComponent<UnityEngine.UI.Image>().canvasRenderer.GetMesh().vertexCount>=4,"Monster projectile not drawn");
        var archive=ReplayArchive.Decode(ReplayArchive.Encode(record));
        Check(archive.loadouts.Where(l=>l.monster!=null).All(l=>l.monster.Stats.Count==6 && l.monster.HasNormalAttack && l.monster.Skills.Count==0),"Unity JSON lost inherited monster data");
        arena.Seek(3.2f);string seek=JsonUtility.ToJson(arena.Timeline.States[101]);arena.Seek(15);arena.Seek(3.2f);
        Check(JsonUtility.ToJson(arena.Timeline.States[101])==seek,"Monster backward seek changed state");
        root.Q<IntegerField>("sandbox-target-hp").value=5000;await RunButton("sandbox-cast-skill_4");
        Check(arena.Record.initial.Where(f=>f.team==1).All(f=>f.maxHp==5000),"Runtime HP override missing");
        Check(arena.Record.events.Any(e=>e.kind==BattleEventKind.Damage && e.actorId>=101),"Single-skill mode disabled monster attacks");
        Check(!arena.Record.events.Any(e=>e.kind==BattleEventKind.Action && e.actorId==1 && e.ability==catalog.Skill("kavern_normal_attack").Name),"Single-skill mode fired Hero basics");
        // A melee skill must approach an attacking ranged monster, even with basics disabled.
        heroField.value=heroField.choices.Single(c=>c.EndsWith("(leenald)"));
        root.Q<IntegerField>("sandbox-target-count").value=1;Pick("sandbox-monster-0","goblin_mage");root.Q<IntegerField>("sandbox-distance").value=2200;
        await RunButton("sandbox-cast-skill_2");
        Check(arena.Record.events.Any(e=>e.kind==BattleEventKind.Move && e.actorId==1) && arena.Record.events.Any(e=>e.kind==BattleEventKind.Stun && e.actorId==1),"Single-skill Hero did not enter skill range");
        Check(JsonUtility.ToJson(catalog.Data)==config,"Runtime changed catalog");
        Check(JsonUtility.ToJson(arena.GetComponent<FormationView>().Selection.Character)==owned,"Sandbox changed HeroDesk");
        Check(!Mirror.NetworkClient.active && !Mirror.NetworkServer.active,"Sandbox started a host/client");
        heroField.value=heroField.choices.Single(c=>c.EndsWith("(kavern)"));root.Q<IntegerField>("sandbox-target-count").value=3;
        Pick("sandbox-monster-0","fighter_goblin");Pick("sandbox-monster-1","skeleton_knight");Pick("sandbox-monster-2","goblin_mage");
        root.Q<IntegerField>("sandbox-target-hp").value=0;root.Q<IntegerField>("sandbox-distance").value=1200;
        await RunButton("sandbox-basic");arena.Seek(3.2f);
        string output=Path.GetFullPath("../Artifacts/MonsterChecks/live-monsters.arena.gz");Directory.CreateDirectory(Path.GetDirectoryName(output));File.WriteAllBytes(output,ReplayArchive.Encode(arena.Record));
        return new{passed=true,checks,monsters=3,oneHero=true,archive=output};
    }
}
