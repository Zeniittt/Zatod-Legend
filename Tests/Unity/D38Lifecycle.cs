using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zatod.Heroes;
using Zatod.Presentation;
public static class D38Lifecycle
{
    public static async Task<object> Run(string report)
    {
        if(!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new InvalidOperationException("Use isolated Play Mode");
        if(SceneManager.GetSceneByPath(ZatodBattleSceneController.ScenePath).isLoaded)throw new InvalidOperationException("Close the active battle first");
        int checks=0;void Check(bool value,string reason){checks++;if(!value)throw new Exception(reason);}
        async Task Until(Func<bool> predicate,string reason){var limit=EditorApplication.timeSinceStartup+10;while(!predicate()){if(EditorApplication.timeSinceStartup>limit)throw new TimeoutException(reason);await Task.Delay(30);}}
        var root=new GameObject("D38LifecycleFixture");
        try
        {
            var pool=root.AddComponent<ZatodPoolManager>();pool.MaxRetained=3;pool.MaxPerKey=2;var resource=HeroDataJson.LoadBundledCatalog().Data.Heroes[0].AnimationSetResource;
            GameObject Create(){var go=new GameObject("Fixture",typeof(ZatodBattleSprite),typeof(AudioSource));go.GetComponent<ZatodBattleSprite>().Initialize(resource);return go;}
            var first=pool.Acquire(resource,root.transform,Create);var visual=first.Object.GetComponent<ZatodBattleSprite>();var state=visual.Set.Clips.First().State;visual.Sample(state,.4f,false,3);visual.Renderer.color=new Color(0,1,0,.1f);visual.Renderer.sortingOrder=12345;
            first.Object.transform.localPosition=new Vector3(7,8,9);first.Object.transform.localRotation=Quaternion.Euler(0,0,60);var block=new MaterialPropertyBlock();block.SetFloat("_NativeBuff",1);visual.Renderer.SetPropertyBlock(block);first.Object.GetComponent<AudioSource>().clip=Resources.Load<AudioClip>("Zatod/Audio/battle_fury_full");
            Check(pool.Release(first),"Release active lease");var next=pool.Acquire(resource,root.transform,Create);Check(next.Object==first.Object && next.Generation!=first.Generation,"Actual object reuse");Check(!pool.Release(first),"Late release cannot retire a new use");
            visual=next.Object.GetComponent<ZatodBattleSprite>();block.Clear();visual.Renderer.GetPropertyBlock(block);
            Check(next.Object.transform.localPosition==Vector3.zero && next.Object.transform.localRotation==Quaternion.identity && next.Object.transform.localScale==Vector3.one,"Reset transform");
            Check(visual.CurrentState==null && visual.SampleSeconds==0 && visual.Renderer.color==Color.white && block.isEmpty && visual.Renderer.sortingOrder==0,"Reset animation/material/alpha/sorting");Check(next.Object.GetComponent<AudioSource>().clip==null && !next.Object.GetComponent<AudioSource>().isPlaying,"Reset audio");
            pool.Release(next);Check(!pool.Release(next),"Double release");
            for(int i=0;i<8;i++){var lease=pool.Acquire("bounded-"+i,root.transform,()=>new GameObject("Bounded"));pool.Release(lease);}Check(pool.Retained<=3 && pool.ActiveCount==0,"Bound retained objects");
            var loader=root.AddComponent<ZatodBattleSceneController>();int failures=0;loader.Failed+=_=>failures++;loader.PrepareAssets=()=>throw new IOException("Intentional missing-asset fixture");loader.Enter();await Until(()=>failures==1 && loader.Phase==ZatodScenePhase.World,"Failed preload cleanup");Check(loader.Stage==null && !SceneManager.GetSceneByPath(ZatodBattleSceneController.ScenePath).isLoaded,"No scene retained after failure");
            loader.PrepareAssets=null;loader.Enter();loader.Leave();await Task.Delay(100);await Until(()=>loader.Phase==ZatodScenePhase.World && loader.Stage==null,"Cancelled loading returns to world");Check(!SceneManager.GetSceneByPath(ZatodBattleSceneController.ScenePath).isLoaded,"Cancelled scene is unloaded");
            loader.Enter();loader.Enter();await Until(()=>loader.Phase==ZatodScenePhase.InBattle,"Enter after cancel");Check(loader.Stage!=null,"Loading can be retried");loader.Leave();await Until(()=>loader.Phase==ZatodScenePhase.World,"Leave after retry");
            var result=new{State="PASS",Checks=checks,FailedPreloadCleanup=true,CancelledLoadCleanup=true,Retry=true,GenerationGuard=true,BoundedPool=true};File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        finally{UnityEngine.Object.Destroy(root);}
    }
}
