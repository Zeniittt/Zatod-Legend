using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
#if UNITY_EDITOR
using UnityEngine.InputSystem;
#endif
using UnityEngine.Rendering;
using Zatod.Networking;
using Zatod.World;
namespace Zatod.Presentation
{
    // World coordinates and the avatar are independent of the deterministic battle simulation.
    public sealed class ZatodWorldView : MonoBehaviour
    {
        sealed class Avatar {public Transform Root,Visual;public TextMeshPro NameLabel;public Animator Animator;public float Facing=1;public bool Walking;public Vector2 From,To;public float Since;}
        ZatodConnection connection;WorldCatalog catalog;[NonSerialized] WorldMapDefinition map;GameObject landscape;
        readonly Dictionary<string,GameObject> landscapes=new Dictionary<string,GameObject>();
        readonly Dictionary<int,Avatar> avatars=new Dictionary<int,Avatar>();
        public const int WorldLayer=8;
        public bool Suspended{get;private set;}
        public void SetSuspended(bool value){if(Suspended==value)return;Suspended=value;Joystick?.CancelInput();if(cameraView!=null){cameraView.enabled=!value;if(!value && map!=null)cameraView.transform.position=CameraTarget();}}
        public Func<bool> InputLocked;public Action<WorldInteractionDefinition> Interact;
        public WorldInteractionDefinition Nearby{get;private set;}
        public Vector2 Position=>new Vector2(x,y);public string MapId=>map?.Id;
        public RectTransform Hud;public UnityEngine.UI.Button InteractionButton;public TextMeshProUGUI MapLabel,Hint,InteractionLabel;
        public ZatodFixedJoystick Joystick{get;private set;}
        Camera cameraView;Vector3 cameraBefore;float sizeBefore;float x,y,facing=1,nextPose;uint revision;
        Material worldMaterial;
        readonly Dictionary<string,TextMeshPro> stageLabels=new Dictionary<string,TextMeshPro>();
        Zatod.Heroes.CampaignCatalog campaign;
        readonly List<ZatodWorldIdleVisual> worldActors=new List<ZatodWorldIdleVisual>();
        void RefreshStages()
        {
            if(connection.Snapshot==null)return;
            foreach(var pair in stageLabels){var definition=campaign.Stage(pair.Key);pair.Value.text=definition.Name+(!definition.KeyStage && connection.Snapshot.Cleared.Contains(pair.Key)?"\n<color=#8dff79>Passed</color>":"");}
        }
        public void Initialize(ZatodConnection c,WorldCatalog data,Transform canvas,TMP_FontAsset font)
        {
            connection=c;catalog=data;cameraView=Camera.main;cameraBefore=cameraView.transform.position;sizeBefore=cameraView.orthographicSize;cameraView.cullingMask=1<<WorldLayer;
            worldMaterial=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");if(worldMaterial==null)throw new Exception("Missing world sprite material.");
            Hud=ZatodStageUi.Box(canvas,"ZatodWorldHUD",0,0,1600,900);Hud.anchorMin=Vector2.zero;Hud.anchorMax=Vector2.one;Hud.offsetMin=Hud.offsetMax=Vector2.zero;
            var banner=ZatodStageUi.Box(Hud,"MapBanner",300,15,1000,70);ZatodStageUi.Image(banner,"campaign_detail_hard_title");banner.anchorMin=banner.anchorMax=banner.pivot=new Vector2(.5f,1);banner.anchoredPosition=new Vector2(0,-15);banner.sizeDelta=new Vector2(620,70);
            MapLabel=ZatodStageUi.Text(banner,"MapName","Town",40,5,540,54,28,font);MapLabel.alignment=TextAlignmentOptions.Center;MapLabel.enableAutoSizing=true;MapLabel.fontSizeMin=18;MapLabel.fontSizeMax=28;
            var back=ZatodStageUi.Button(Hud,"Town","buttion_big",24,20,180,58);ZatodStageUi.Text(back.transform,"Title","Town",10,3,160,48,23,font).alignment=TextAlignmentOptions.Center;
            back.onClick.AddListener(()=>{if(map==null)return;var portal=map.Interactions.FirstOrDefault(p=>p.Kind==WorldInteractionKind.Portal && p.TargetId=="town");if(portal!=null)connection.WorldTravel(portal.Id);});
            Hint=ZatodStageUi.Text(Hud,"Controls","",24,96,750,44,20,font);
            Joystick=Instantiate(Resources.Load<GameObject>("Zatod/UI/World/ZatodFixedJoystick"),Hud,false).GetComponent<ZatodFixedJoystick>();
            Joystick.CanMove=()=>connection.Connected && map!=null && !(InputLocked?.Invoke()??true) && !Suspended;
            InteractionButton=ZatodStageUi.Button(Hud,"Interact","buttion_big",605,750,390,75);
            var ir=(RectTransform)InteractionButton.transform;ir.anchorMin=ir.anchorMax=ir.pivot=new Vector2(.5f,0);ir.anchoredPosition=new Vector2(0,24);
            InteractionLabel=ZatodStageUi.Text(InteractionButton.transform,"Caption","",12,5,366,64,25,font);InteractionLabel.alignment=TextAlignmentOptions.Center;InteractionLabel.enableAutoSizing=true;InteractionLabel.fontSizeMin=18;InteractionLabel.fontSizeMax=25;InteractionLabel.textWrappingMode=TextWrappingModes.NoWrap;
            InteractionButton.onClick.AddListener(()=>{if(Nearby!=null && !InputLocked())Interact?.Invoke(Nearby);});InteractionButton.gameObject.SetActive(false);
            campaign=Zatod.Heroes.CampaignDataJson.Load(connection.ClientCatalog);BuildMaps();connection.WorldChanged+=Snapshot;connection.Changed+=RefreshStages;
        }
        void Snapshot()
        {
            var self=connection.WorldSelf;
            if(self==null){Joystick.CancelInput();foreach(var a in avatars.Values)Destroy(a.Root.gameObject);avatars.Clear();map=null;landscape=null;return;}
            if(map==null || map.Id!=self.MapId || revision!=self.MapRevision)
            {
                Joystick.CancelInput();revision=self.MapRevision;x=self.X;y=self.Y;facing=self.Facing;LoadMap(catalog.Map(self.MapId));
            }
            foreach(var player in connection.WorldPlayers)
            {
                if(!avatars.TryGetValue(player.ConnectionId,out var a))
                {
                    var root=new GameObject("Avatar_"+player.ConnectionId).transform;root.SetParent(transform,false);root.gameObject.layer=WorldLayer;
                    var visual=Visual("unit",root,1.7f);a=new Avatar{Root=root,Visual=visual,Animator=visual.GetComponentInChildren<Animator>(),From=new Vector2(player.X,player.Y),To=new Vector2(player.X,player.Y)};
                    avatars.Add(player.ConnectionId,a);root.position=new Vector3(player.X,player.Y,0);
                    var label=new GameObject("PlayerName").AddComponent<TextMeshPro>();label.transform.SetParent(root,false);label.gameObject.layer=WorldLayer;label.transform.localPosition=new Vector3(0,2,0);label.font=MapLabel.font;label.text=player.Name+(player.ConnectionId==connection.WorldSelfId?" (You)":"");label.fontSize=2.3f;label.alignment=TextAlignmentOptions.Center;label.rectTransform.sizeDelta=new Vector2(7,.5f);label.GetComponent<MeshRenderer>().sortingOrder=20000;label.richText=false;a.NameLabel=label;
                }
                a.NameLabel.text=player.Name+(player.ConnectionId==connection.WorldSelfId?" (You)":"");
                a.From=new Vector2(a.Root.position.x,a.Root.position.y);a.To=new Vector2(player.X,player.Y);a.Since=Time.unscaledTime;
                if(player.ConnectionId!=connection.WorldSelfId)Animate(a,player.Walking,player.Facing);
            }
            foreach(int id in avatars.Keys.Where(id=>!connection.WorldPlayers.Any(p=>p.ConnectionId==id)).ToArray()){Destroy(avatars[id].Root.gameObject);avatars.Remove(id);}
        }
        Transform Visual(string resource,Transform parent,float height)
        {
            var prefab=Resources.Load<GameObject>("Zatod/World/Visuals/"+resource);if(prefab==null)throw new Exception("Missing world visual: "+resource);
            var go=Instantiate(prefab,parent,false);UseWorldMaterial(go);var renderers=go.GetComponentsInChildren<Renderer>();
            var bounds=renderers[0].bounds;foreach(var r in renderers.Skip(1))bounds.Encapsulate(r.bounds);
            foreach(var t in go.GetComponentsInChildren<Transform>(true))t.gameObject.layer=WorldLayer;
            go.transform.localScale*=height/Mathf.Max(.01f,bounds.size.y);
            bounds=renderers[0].bounds;foreach(var r in renderers.Skip(1))bounds.Encapsulate(r.bounds);
            go.transform.position+=new Vector3(parent.position.x-bounds.center.x,parent.position.y-bounds.min.y,0);
            var sort=parent.GetComponent<SortingGroup>();if(sort==null)sort=parent.gameObject.AddComponent<SortingGroup>();sort.sortingOrder=Depth(parent.position.y);
            return go.transform;
        }
        static int Depth(float py)=>10000-Mathf.RoundToInt(py*100);
        void UseWorldMaterial(GameObject visual)
        {
            foreach(var r in visual.GetComponentsInChildren<SpriteRenderer>(true))
                if(r.sharedMaterial!=null && r.sharedMaterial.shader.name=="Universal Render Pipeline/2D/Sprite-Lit-Default")r.sharedMaterial=worldMaterial;
        }
        void BuildMaps()
        {
            foreach(var definition in catalog.Data.Maps)
            {
                map=definition;landscape=new GameObject("ZatodMap_"+map.Id);landscape.transform.SetParent(transform,false);
                landscape.layer=WorldLayer;landscape.transform.position=new Vector3(map.OriginX,map.OriginY,0);landscapes.Add(map.Id,landscape);
                var bg=Instantiate(Resources.Load<GameObject>("Zatod/World/Visuals/"+map.VisualResource),landscape.transform);
                UseWorldMaterial(bg);foreach(var t in bg.GetComponentsInChildren<Transform>(true))t.gameObject.layer=WorldLayer;
                var sr=bg.GetComponentInChildren<SpriteRenderer>();var b=sr.bounds;
                bg.transform.localScale=new Vector3((map.MaxX-map.MinX+5)/b.size.x,(map.MaxY-map.MinY+5)/b.size.y,1);
                bg.transform.position=new Vector3((map.MinX+map.MaxX)/2,(map.MinY+map.MaxY)/2,0);sr.sortingOrder=-30000;
                foreach(var p in map.Props)Place(p.Id,p.VisualResource,p.X,p.Y,p.Height);
                foreach(var p in map.Interactions)
                {
                    Transform point;
                    if(p.Kind==WorldInteractionKind.Stage)
                    {
                        var stage=campaign.Stage(p.TargetId);var enemies=stage.Waves.Last().Enemies;
                        var boss=enemies.FirstOrDefault(e=>e.Id==stage.WorldBossEnemyId)??enemies.OrderByDescending(e=>e.Boss).First();
                        string resource=boss.Kind==Zatod.Heroes.SpawnKind.Hero?connection.ClientCatalog.Hero(boss.DefinitionId).AnimationSetResource:connection.ClientCatalog.Monster(boss.DefinitionId).AnimationSetResource;
                        point=PlaceActor(p,resource);
                    }
                    else if(!string.IsNullOrEmpty(p.AnimationSetResource))point=PlaceActor(p,p.AnimationSetResource);
                    else point=Place(p.Id,p.VisualResource,p.X,p.Y,p.Height);
                    var label=new GameObject("PointLabel").AddComponent<TextMeshPro>();label.gameObject.layer=WorldLayer;label.transform.SetParent(point,false);
                    label.transform.localPosition=new Vector3(0,p.Height+.35f,0);label.text=p.Label;label.font=MapLabel.font;label.fontSize=2.4f;
                    label.alignment=TextAlignmentOptions.Center;label.rectTransform.sizeDelta=new Vector2(8,.6f);label.enableAutoSizing=true;label.fontSizeMin=1.4f;label.fontSizeMax=2.4f;label.textWrappingMode=TextWrappingModes.NoWrap;label.GetComponent<MeshRenderer>().sortingOrder=25000;if(p.Kind==WorldInteractionKind.Stage)stageLabels.Add(p.TargetId,label);
                }
            }
            map=null;landscape=null;
        }
        Transform PlaceActor(WorldInteractionDefinition point,string resource)
        {
            var root=new GameObject(point.Id).transform;root.SetParent(landscape.transform,false);root.position=new Vector3(point.X,point.Y,0);root.gameObject.layer=WorldLayer;
            var actor=root.gameObject.AddComponent<ZatodWorldIdleVisual>();actor.Initialize(resource,point.Height);worldActors.Add(actor);
            root.gameObject.AddComponent<SortingGroup>().sortingOrder=Depth(point.Y);return root;
        }
        void LoadMap(WorldMapDefinition definition)
        {
            map=definition;landscape=landscapes[map.Id];MapLabel.text=map.Name;
            cameraView.orthographicSize=7.8f;cameraView.transform.position=CameraTarget();
        }
        Transform Place(string id,string resource,float px,float py,float height){var root=new GameObject(id).transform;root.SetParent(landscape.transform,false);root.position=new Vector3(px,py,0);Visual(resource,root,height);return root;}
        Vector3 CameraTarget()
        {
            cameraView.orthographicSize=Mathf.Min(7.8f,(map.MaxY-map.MinY)/2,(map.MaxX-map.MinX)/(2*Mathf.Max(.1f,cameraView.aspect)));
            float halfWidth=cameraView.orthographicSize*cameraView.aspect;
            return new Vector3(Mathf.Clamp(x,map.MinX+halfWidth,map.MaxX-halfWidth),Mathf.Clamp(y,map.MinY+cameraView.orthographicSize,map.MaxY-cameraView.orthographicSize),-10);
        }
        static void Animate(Avatar a,bool walking,float direction)
        {
            if(a.Animator!=null && (a.Walking!=walking || !a.Animator.isInitialized)){a.Animator.Play(walking?"run":"idle",0,0);a.Animator.applyRootMotion=false;}
            a.Walking=walking;
            // The supplied Unit faces left at positive scale. Mirror the outer
            // wrapper for right-facing poses; the Animator keeps its native rig.
            var scale=a.Visual.localScale;float desired=Mathf.Abs(scale.x)*(direction<0?1:-1);
            if(scale.x!=desired)
            {
                scale.x=desired;a.Visual.localScale=scale;
                // Visual() centers the native art with a local X offset. Mirror
                // that offset too so changing facing preserves the ground anchor.
                var offset=a.Visual.localPosition;offset.x=-offset.x;a.Visual.localPosition=offset;
            }
            a.Facing=direction;
        }
        void Update()
        {
            if(connection==null)return;
            bool locked=Suspended || (InputLocked?.Invoke()??true);Hud.gameObject.SetActive(!Suspended && !locked && connection.Connected);
            if(map==null || string.IsNullOrEmpty(map.Id))return;
            Vector2 input=locked?Vector2.zero:Joystick.Movement;
#if UNITY_EDITOR
            var k=Keyboard.current;
            if(!locked && k!=null)
            {
                var keyboard=new Vector2((k.dKey.isPressed||k.rightArrowKey.isPressed?1:0)-(k.aKey.isPressed||k.leftArrowKey.isPressed?1:0),(k.wKey.isPressed||k.upArrowKey.isPressed?1:0)-(k.sKey.isPressed||k.downArrowKey.isPressed?1:0));
                if(keyboard.sqrMagnitude>0)input=keyboard;
            }
#endif
            float ox=x,oy=y;WorldMovement.Move(map,ref x,ref y,input.x,input.y,Time.unscaledDeltaTime);bool walking=Mathf.Abs(x-ox)+Mathf.Abs(y-oy)>.00001f;if(input.x!=0)facing=input.x<0?-1:1;
            if(Time.unscaledTime>=nextPose){nextPose=Time.unscaledTime+.05f;connection.SendWorldPose(x,y,facing,walking);}
            foreach(var pair in avatars)
            {
                var a=pair.Value;if(pair.Key==connection.WorldSelfId){a.Root.position=new Vector3(x,y,0);Animate(a,walking,facing);}
                else{var pos=Vector2.Lerp(a.From,a.To,Mathf.Clamp01((Time.unscaledTime-a.Since)/.1f));a.Root.position=new Vector3(pos.x,pos.y,0);}
                a.Root.GetComponent<SortingGroup>().sortingOrder=Depth(a.Root.position.y);
            }
            Nearby=map.Interactions.Where(p=>(new Vector2(p.X,p.Y)-Position).sqrMagnitude<=p.Radius*p.Radius).OrderBy(p=>(new Vector2(p.X,p.Y)-Position).sqrMagnitude).FirstOrDefault();
            InteractionButton.gameObject.SetActive(Nearby!=null);if(Nearby!=null)InteractionLabel.text=Nearby.Label;
            if(!Suspended)cameraView.transform.position=Vector3.Lerp(cameraView.transform.position,CameraTarget(),1-Mathf.Exp(-10*Time.unscaledDeltaTime));
        }
        void OnDestroy(){if(connection!=null){connection.WorldChanged-=Snapshot;connection.Changed-=RefreshStages;}if(cameraView!=null){cameraView.enabled=true;cameraView.cullingMask=-1;cameraView.transform.position=cameraBefore;cameraView.orthographicSize=sizeBefore;}}
    }
}
