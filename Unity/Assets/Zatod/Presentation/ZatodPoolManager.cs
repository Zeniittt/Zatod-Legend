using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
namespace Zatod.Presentation
{
    // Presentation-only pool. Leases prevent late callbacks releasing a newer use.
    public sealed class ZatodPoolManager:MonoBehaviour
    {
        public readonly struct Lease
        {
            public readonly GameObject Object;public readonly uint Generation;
            internal Lease(GameObject value,uint generation){Object=value;Generation=generation;}
        }
        sealed class Entry{public string Key;public uint Generation;public bool Active;}
        readonly Dictionary<GameObject,Entry> entries=new Dictionary<GameObject,Entry>();
        readonly Dictionary<string,Stack<GameObject>> idle=new Dictionary<string,Stack<GameObject>>();
        public int Created{get;private set;}public int Reused{get;private set;}public int Retained{get;private set;}
        public int ActiveCount{get;private set;}public int MaxRetained=96,MaxPerKey=4;
        public Lease Acquire(string key,Transform parent,Func<GameObject> create)
        {
            GameObject value=null;Entry entry=null;
            if(idle.TryGetValue(key,out var available))while(available.Count>0 && value==null)
            {value=available.Pop();Retained--;if(value!=null){entry=entries[value];Reused++;}}
            if(value==null){value=create();value.SetActive(false);entry=new Entry{Key=key};entries.Add(value,entry);Created++;}
            entry.Active=true;entry.Generation++;ActiveCount++;value.transform.SetParent(parent,false);Reset(value);value.SetActive(true);
            return new Lease(value,entry.Generation);
        }
        public bool Release(Lease lease)
        {
            var value=lease.Object;
            if(value==null || !entries.TryGetValue(value,out var entry) || !entry.Active || entry.Generation!=lease.Generation)return false;
            entry.Active=false;ActiveCount--;value.SetActive(false);Reset(value);value.transform.SetParent(transform,false);
            if(!idle.TryGetValue(entry.Key,out var available))idle.Add(entry.Key,available=new Stack<GameObject>());
            if(Retained>=MaxRetained || available.Count>=MaxPerKey){entries.Remove(value);Destroy(value);}else{available.Push(value);Retained++;}
            return true;
        }
        public void Prewarm(string key,int count,Func<GameObject> create)
        {
            var leases=new List<Lease>();for(int i=0;i<Math.Min(count,MaxPerKey);i++)leases.Add(Acquire(key,transform,create));
            foreach(var lease in leases)Release(lease);
        }
        public void ReleaseAll()
        {
            var leases=new List<Lease>();foreach(var item in entries)if(item.Key!=null && item.Value.Active)leases.Add(new Lease(item.Key,item.Value.Generation));
            foreach(var lease in leases)Release(lease);
        }
        static void Reset(GameObject value)
        {
            foreach(var script in value.GetComponentsInChildren<MonoBehaviour>(true))script.StopAllCoroutines();
            foreach(var audio in value.GetComponentsInChildren<AudioSource>(true)){audio.Stop();audio.clip=null;audio.pitch=1;}
            foreach(var sprite in value.GetComponentsInChildren<ZatodBattleSprite>(true))sprite.ResetForReuse();
            foreach(var renderer in value.GetComponentsInChildren<SpriteRenderer>(true)){renderer.color=Color.white;renderer.flipX=renderer.flipY=false;renderer.SetPropertyBlock(null);renderer.sortingOrder=0;}
            foreach(var text in value.GetComponentsInChildren<TMP_Text>(true)){text.text="";text.color=Color.white;text.fontStyle=FontStyles.Normal;text.rectTransform.localScale=Vector3.one;}
            value.transform.localPosition=Vector3.zero;value.transform.localRotation=Quaternion.identity;value.transform.localScale=Vector3.one;
        }
    }
}
