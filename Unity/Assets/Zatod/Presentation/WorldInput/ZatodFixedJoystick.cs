using System;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Zatod.Presentation
{
    // Native Joystick Pack art/math, with Zatod's pointer ownership and world gating.
    public sealed class ZatodFixedJoystick : FixedJoystick, IDragHandler, ICancelHandler
    {
        public Func<bool> CanMove;
        public bool PointerHeld=>pointerId.HasValue;
        public Vector2 Movement=>PointerHeld && isActiveAndEnabled && (CanMove?.Invoke()??true)?Vector2.ClampMagnitude(Direction,1):Vector2.zero;
        int? pointerId;
        bool ready;
        Vector2 parentSize;
        protected override void Start(){base.Start();ready=true;CancelInput();Fit();}
        public override void OnPointerDown(PointerEventData data)
        {
            if(!ready || !isActiveAndEnabled || !(CanMove?.Invoke()??true) || pointerId.HasValue)return;
            pointerId=data.pointerId;base.OnPointerDown(data);
        }
        // The source OnDrag is non-virtual. Reimplement its event interface so a
        // second touch cannot bypass our owner check through the base handler.
        public new void OnDrag(PointerEventData data)
        {
            if(pointerId!=data.pointerId)return;
            if(!(CanMove?.Invoke()??true)){CancelInput();return;}
            base.OnDrag(data);
        }
        public override void OnPointerUp(PointerEventData data){if(data!=null && pointerId==data.pointerId)CancelInput();}
        public void OnCancel(BaseEventData data)=>CancelInput();
        public void CancelInput(){pointerId=null;if(ready)base.OnPointerUp(null);}
        void OnDisable()=>CancelInput();
        void OnApplicationFocus(bool focused){if(!focused)CancelInput();}
        void OnApplicationPause(bool paused){if(paused)CancelInput();}
        void Update(){if(PointerHeld && !(CanMove?.Invoke()??true))CancelInput();}
        void LateUpdate()=>Fit();
        public void Fit()
        {
            if(!(transform.parent is RectTransform parent))return;
            var size=parent.rect.size;if(size==parentSize)return;parentSize=size;CancelInput();
            var rect=(RectTransform)transform;rect.anchorMin=rect.anchorMax=new Vector2(.14f,.22f);rect.pivot=new Vector2(.5f,.5f);rect.anchoredPosition=Vector2.zero;rect.localScale=Vector3.one;
            float diameter=Mathf.Clamp(size.y*.25f,180,230);rect.sizeDelta=Vector2.one*diameter;
            // The native Fixed prefab's handle is half the background diameter.
            var knob=transform.Find("Handle") as RectTransform;if(knob!=null)knob.sizeDelta=Vector2.one*diameter*.5f;
        }
    }
}
