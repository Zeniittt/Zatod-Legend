using System;
using UnityEngine;
using UnityEngine.EventSystems;
namespace Zatod.Presentation
{
    // One press sends one level. Repeats only while the pointer remains held inside.
    public sealed class ZatodRepeatButton:MonoBehaviour,IPointerDownHandler,IPointerUpHandler,IPointerExitHandler,ISubmitHandler
    {
        public Action Press;
        public Func<bool> CanPress;
        bool held;float next;
        public void OnPointerDown(PointerEventData data){if(data.button!=PointerEventData.InputButton.Left)return;held=true;next=Time.unscaledTime+.45f;Fire();}
        public void OnPointerUp(PointerEventData data)=>held=false;
        public void OnPointerExit(PointerEventData data)=>held=false;
        public void OnSubmit(BaseEventData data)=>Fire();
        void Update(){if(!held || Time.unscaledTime<next)return;next=Time.unscaledTime+.16f;Fire();}
        void Fire(){if(CanPress?.Invoke()==true)Press?.Invoke();}
        void OnDisable()=>held=false;
        public void Cancel()=>held=false;
    }
}
