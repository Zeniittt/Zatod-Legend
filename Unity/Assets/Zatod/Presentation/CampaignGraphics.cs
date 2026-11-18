using UnityEngine;

namespace Zatod.Presentation
{
    [RequireComponent(typeof(CanvasRenderer))]
    public sealed class CampaignMapGraphic : UnityEngine.UI.MaskableGraphic
    {
        public Vector2[] Points=new Vector2[0];
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear();var r=rectTransform.rect;
            FormationFrame.Quad(vh,r,HeroUi.Hex("C7AC77"));
            FormationFrame.Quad(vh,new Rect(r.xMin+8,r.yMin+8,r.width-16,r.height-16),HeroUi.Hex("D7C194"));
            for(int row=0;row<5;row++)for(int col=0;col<13;col++)
            {
                float x=r.xMin+col*r.width/12+((row%2)*30),y=r.yMin+45+row*120;
                Triangle(vh,new Vector2(x-28,y),new Vector2(x,y+24),new Vector2(x+32,y),new Color(.34f,.25f,.13f,.11f));
                Triangle(vh,new Vector2(x,y+24),new Vector2(x+9,y+4),new Vector2(x+32,y),new Color(.29f,.20f,.10f,.09f));
            }
            for(int i=1;i<Points.Length;i++)
            {
                var a=Point(r,Points[i-1]);var b=Point(r,Points[i]);var previous=a;
                for(int s=1;s<=24;s++)
                {float t=s/24f;var next=Vector2.Lerp(a,b,t);next.y+=Mathf.Sin(t*Mathf.PI)*38*(i%2==0?1:-1);Line(vh,previous,next,20,HeroUi.Hex("715237"));Line(vh,previous,next,11,HeroUi.Hex("9C7950"));previous=next;}
            }
        }
        static Vector2 Point(Rect r,Vector2 p)=>new Vector2(r.xMin+p.x*r.width,r.yMax-p.y*r.height);
        static void Triangle(UnityEngine.UI.VertexHelper vh,Vector2 a,Vector2 b,Vector2 c,Color color)
        {int n=vh.currentVertCount;vh.AddVert(a,color,Vector2.zero);vh.AddVert(b,color,Vector2.zero);vh.AddVert(c,color,Vector2.zero);vh.AddTriangle(n,n+1,n+2);}
        static void Line(UnityEngine.UI.VertexHelper vh,Vector2 a,Vector2 b,float width,Color color)
        {var normal=new Vector2(-(b-a).y,(b-a).x).normalized*width*.5f;int n=vh.currentVertCount;foreach(var p in new[]{a-normal,a+normal,b+normal,b-normal})vh.AddVert(p,color,Vector2.zero);vh.AddTriangle(n,n+1,n+2);vh.AddTriangle(n,n+2,n+3);}
    }
    [RequireComponent(typeof(CanvasRenderer))]
    public sealed class CampaignNodeGraphic : UnityEngine.UI.MaskableGraphic
    {
        public bool Locked,Cleared,Selected;
        protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper vh)
        {
            vh.Clear();var r=rectTransform.rect;var center=r.center;
            Ellipse(vh,center+new Vector2(0,-27),new Vector2(r.width*.49f,33),HeroUi.Hex("57412C"));
            Ellipse(vh,center+new Vector2(0,-18),new Vector2(r.width*.46f,33),Selected?HeroUi.Hex("E8CB70"):HeroUi.Hex("AC9B7A"));
            Ellipse(vh,center+new Vector2(0,-13),new Vector2(r.width*.40f,26),Cleared?HeroUi.Hex("708B53"):HeroUi.Hex("5C6860"));
            for(int i=0;i<3;i++)
            {
                var p=center+new Vector2((i-1)*32,i==1?30:6);var c=Locked?HeroUi.Hex("73786E"):HeroUi.Hex(i==1?"283E39":"3F5750");
                int n=vh.currentVertCount;vh.AddVert(p+new Vector2(-23,-35),c,Vector2.zero);vh.AddVert(p+new Vector2(0,44),c,Vector2.zero);vh.AddVert(p+new Vector2(23,-35),c,Vector2.zero);vh.AddTriangle(n,n+1,n+2);
                Ellipse(vh,p+new Vector2(-6,-2),new Vector2(3,5),HeroUi.Hex("E5DFA6"));Ellipse(vh,p+new Vector2(6,-2),new Vector2(3,5),HeroUi.Hex("E5DFA6"));
            }
        }
        static void Ellipse(UnityEngine.UI.VertexHelper vh,Vector2 center,Vector2 radius,Color c)
        {int n=vh.currentVertCount;vh.AddVert(center,c,Vector2.zero);for(int i=0;i<32;i++){float a=i*Mathf.PI/16;vh.AddVert(center+new Vector2(Mathf.Cos(a)*radius.x,Mathf.Sin(a)*radius.y),c,Vector2.zero);}for(int i=0;i<32;i++)vh.AddTriangle(n,n+1+i,n+1+(i+1)%32);}
    }
}
