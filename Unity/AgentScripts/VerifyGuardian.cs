using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyGuardian
{
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        string Hash(string path){using(var sha=SHA256.Create())return Convert.ToBase64String(sha.ComputeHash(File.ReadAllBytes(path)));}
        const string source="E:/hoc/TinIT/TinUnity/MyProject/Zatod Legend/Assets/Graphics/Enemies/Guardian";
        var catalog=HeroDataJson.LoadBundledCatalog();string config=JsonUtility.ToJson(catalog.Data);
        var definition=catalog.Monster("guardian");
        Check(definition.Name=="Guardian" && definition.Position==HeroPosition.Front && definition.SkillIds.Count==0,"Guardian config");
        var set=JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(definition.AnimationSetResource).text);
        var prefab=Resources.Load<GameObject>(definition.BodyPrefabResource);
        Check(prefab!=null && prefab.GetComponent<SpriteRenderer>().sprite!=null,"Body prefab missing");
        Check(Resources.Load<Sprite>("MonsterPortraits/guardian").rect.width==36,"Portrait crop missing");
        int total=0;
        foreach(var spec in new[]{("Idle","Idle",15,64),("Run","Run",8,96),("NormalAttack","Attack",22,144),("Death","Death",15,96),("TakeHit","Shield",7,96)})
        {
            string filename="noBKG_Knight"+spec.Item2+"_strip.png";
            Check(Hash(source+"/"+filename)==Hash("Assets/Zatod/Art/Monsters/Guardian/"+filename),"Art bytes changed: "+filename);
            string path="Assets/Zatod/Art/Monsters/Guardian/"+filename;
            var importer=(TextureImporter)AssetImporter.GetAtPath(path);var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(path);
            Check(importer.textureCompression==TextureImporterCompression.Uncompressed && texture.format==TextureFormat.RGBA32 && texture.width==spec.Item3*spec.Item4,"Texture compression or rescaling: "+filename);
            var entry=set.Clips.Single(c=>c.State==spec.Item1);
            var clip=Resources.Load<AnimationClip>(entry.ClipResource);
            var keys=AnimationUtility.GetObjectReferenceCurve(clip,EditorCurveBinding.PPtrCurve("",typeof(SpriteRenderer),"m_Sprite"));
            Check(keys.Length==spec.Item3 && entry.SourceFrames.Count==spec.Item3,"Frame count: "+spec.Item1);
            Check(Mathf.Abs(entry.DurationSeconds-spec.Item3/12f)<.0001f,"Duration: "+spec.Item1);
            Check(entry.Loop==(spec.Item1=="Idle" || spec.Item1=="Run"),"Loop: "+spec.Item1);
            foreach(var key in keys)
            {var sprite=(Sprite)key.value;Check(sprite.rect.width==spec.Item4 && sprite.rect.height==64 && sprite.pixelsPerUnit==25 && Mathf.Abs(sprite.pivot.y-20)<.001f,"Rect/ground/PPU: "+spec.Item1);}
            total+=keys.Length;
        }
        Check(total==67 && set.Clips.Single(c=>c.State=="Stun").ClipResource==set.Clips.Single(c=>c.State=="TakeHit").ClipResource,"Shield alias");
        var controller=(AnimatorController)prefab.GetComponent<Animator>().runtimeAnimatorController;
        Check(controller.layers[0].stateMachine.states.Length==6,"Animator states");
        var sandbox=Resources.FindObjectsOfTypeAll<HeroCombatSandboxWindow>().First();
        Check(sandbox.rootVisualElement.Q<DropdownField>("sandbox-monster-choice").choices.Any(c=>c.EndsWith("(guardian)")),"Guardian absent from Sandbox");
        // Sample in a temporary canvas without replacing the currently open user replay.
        var canvas=new GameObject("GuardianVerification",typeof(RectTransform),typeof(Canvas));
        canvas.hideFlags=HideFlags.HideAndDontSave;canvas.GetComponent<Canvas>().renderMode=RenderMode.ScreenSpaceOverlay;
        var spriteObject=new GameObject("GuardianSample",typeof(RectTransform));spriteObject.transform.SetParent(canvas.transform,false);
        var player=spriteObject.AddComponent<ReplaySprite>();
        try
        {
            player.Initialize(definition.AnimationSetResource);
            foreach(var entry in set.Clips)foreach(bool right in new[]{true,false})
            {
                player.Sample(entry.State,.35f,right,.5f);Canvas.ForceUpdateCanvases();
                var image=player.GetComponent<UnityEngine.UI.Image>();
                Check(player.CurrentState==entry.State && image.enabled && image.sprite!=null && image.canvasRenderer.GetMesh().vertexCount>=4,"Runtime sprite sample: "+entry.State);
                Check(Mathf.Sign(spriteObject.transform.localScale.x)==(right?1:-1),"Facing: "+entry.State);
            }
        }
        finally{UnityEngine.Object.DestroyImmediate(canvas);}
        var settings=new HeroSandboxSettings{HeroId="leenald",RankId="purple",Mode=SandboxTestMode.BasicAttack,HpPercent=100,DurationSeconds=30,
            MonsterIds=new System.Collections.Generic.List<string>{"guardian","guardian"},TargetDistance=1200,TargetSpacing=220};
        var battle=HeroCombatSandbox.Build(catalog,settings);
        Check(battle.events.Any(e=>e.actorId>=101 && e.kind==BattleEventKind.Move),"Guardian never runs");
        Check(battle.events.Any(e=>e.actorId>=101 && e.kind==BattleEventKind.Damage && e.targetId==1),"Guardian does not deal damage");
        Check(battle.events.Any(e=>e.targetId>=101 && e.kind==BattleEventKind.Death),"Guardian death missing");
        Check(battle.loadouts.Where(l=>l.kind==CombatantKind.Monster).Select(l=>l.monster.MonsterInstanceId).Distinct().Count()==2,"Duplicate Guardian identities");
        settings.Mode=SandboxTestMode.SingleSkill;settings.SkillSlotId="ultimate";settings.TargetHp=10000;
        var stunBattle=HeroCombatSandbox.Build(catalog,settings);
        Check(stunBattle.events.Any(e=>e.kind==BattleEventKind.Stun && e.targetId>=101),"Guardian not controlled by Leenald ultimate");
        var loaded=ReplayArchive.Decode(ReplayArchive.Encode(battle));
        Check(loaded.initial.Count(f=>f.monsterDefinitionId=="guardian")==2,"Archive identity");
        var replay=new ReplayTimeline(loaded);replay.Seek(30);string snapshot=JsonUtility.ToJson(replay.States[101]);replay.Seek(200);replay.Seek(30);
        Check(JsonUtility.ToJson(replay.States[101])==snapshot,"Guardian backward seek");
        Check(JsonUtility.ToJson(catalog.Data)==config,"Battle mutated Guardian config");
        string artifact=Path.GetFullPath("../Artifacts/GuardianChecks/guardian.arena.gz");Directory.CreateDirectory(Path.GetDirectoryName(artifact));File.WriteAllBytes(artifact,ReplayArchive.Encode(battle));
        return new{passed=true,checks,frames=total,artifact};
    }
}
