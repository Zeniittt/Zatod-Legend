using System;
using System.Collections;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Zatod.Presentation
{
    public enum ZatodScenePhase {World,LoadingBattle,InBattle,ReturningWorld}
    public sealed class ZatodBattleSceneController : MonoBehaviour
    {
        public const string ScenePath="Assets/Zatod/Scenes/ZatodBattle.unity";
        [SerializeField] string battleScenePath=ScenePath;
        public ZatodScenePhase Phase{get;private set;}
        public ZatodBattleStage Stage{get;private set;}
        public bool OccupiesClient=>Phase!=ZatodScenePhase.World;
        public event Action Changed;
        public event Action<string> Failed;
        bool wanted,running;
        public void Enter(){wanted=true;StartPump();}
        public void Leave(){wanted=false;StartPump();}
        void StartPump(){if(!running && isActiveAndEnabled)StartCoroutine(Pump());}
        void SetPhase(ZatodScenePhase value){Phase=value;Changed?.Invoke();}
        IEnumerator Pump()
        {
            running=true;
            while(wanted || Stage!=null)
            {
                if(wanted && Stage==null)
                {
                    SetPhase(ZatodScenePhase.LoadingBattle);AsyncOperation load=null;string error=null;
                    try{load=SceneManager.LoadSceneAsync(battleScenePath,LoadSceneMode.Additive);}catch(Exception e){error=e.Message;}
                    if(load==null){wanted=false;running=false;SetPhase(ZatodScenePhase.World);Failed?.Invoke(error??"Cannot load Zatod battle scene.");yield break;}
                    load.completed+=_=>{if(this==null){var abandoned=SceneManager.GetSceneByPath(battleScenePath);if(abandoned.IsValid() && abandoned.isLoaded)SceneManager.UnloadSceneAsync(abandoned);}};
                    yield return load;
                    var loaded=SceneManager.GetSceneByPath(battleScenePath);
                    Stage=loaded.GetRootGameObjects().SelectMany(g=>g.GetComponentsInChildren<ZatodBattleStage>(true)).SingleOrDefault();
                    if(Stage==null)
                    {
                        wanted=false;yield return SceneManager.UnloadSceneAsync(loaded);running=false;SetPhase(ZatodScenePhase.World);Failed?.Invoke("Battle scene has no ZatodBattleStage.");yield break;
                    }
                    if(wanted)SetPhase(ZatodScenePhase.InBattle);
                }
                if(!wanted && Stage!=null)
                {
                    Stage.Clear();SetPhase(ZatodScenePhase.ReturningWorld);var scene=Stage.gameObject.scene;Stage=null;
                    yield return SceneManager.UnloadSceneAsync(scene);
                }
                else break;
            }
            running=false;if(Stage==null)SetPhase(ZatodScenePhase.World);
        }
        void OnDestroy()
        {
            wanted=false;
            if(Application.isPlaying && Stage!=null && Stage.gameObject.scene.IsValid() && Stage.gameObject.scene.isLoaded)SceneManager.UnloadSceneAsync(Stage.gameObject.scene);
        }
    }
}
