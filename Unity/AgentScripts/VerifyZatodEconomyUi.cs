using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using TMPro;
using Zatod.Heroes;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
return await VerifyZatodEconomyUi.Run();
public static class VerifyZatodEconomyUi
{
 const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
 public static async Task<object> Run()
 {
  if(!Application.isPlaying)throw new Exception("Enter Play first.");var connection=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(connection.Connected)throw new Exception("Fixture needs disconnected client.");
  var host=connection.GetComponent<ZatodPrototypeView>();var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var rules=ProgressionDataJson.LoadBundled();long now=DateTimeOffset.UtcNow.ToUnixTimeSeconds();
  var account=campaign.CreateDemoCharacter(catalog);rules.Initialize(account,now);account.Exp=24;foreach(var hero in account.HeroDesk)hero.Level=10;account.HeroDesk.Last().Level=2;account.HeroDesk.Last().Exp=29;
  var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),account,progression:rules,clock:()=>now);
  var match=session.BeginCampaign("chapter_one_stage_1",null,17,Guid.NewGuid().ToString("N"));var record=new ZatodBattleSimulation(match).RunToCompletion();if(record.Winner!=0)throw new Exception("Fixture must win.");session.ValidateCampaign(record);
  typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(connection,new ZatodAccountSnapshot{ServerTime=now,Account=account,LastCampaignReward=session.LastCampaignReward});
  int checks=0;void Check(bool yes,string why){checks++;if(!yes)throw new Exception(why);}
  string folder=Path.GetFullPath("../Artifacts/ZatodEconomyChecks/ui");Directory.CreateDirectory(folder);
  var resultView=(ZatodBattleResultView)typeof(ZatodPrototypeView).GetField("battleResult",Flags).GetValue(host);
  var assembly=typeof(Editor).Assembly;var viewType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(viewType);var selected=viewType.GetProperty("selectedSizeIndex",Flags);int oldIndex=(int)selected.GetValue(view);
  var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var sizes=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
  var group=sizesType.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var gt=group.GetType();int initialCount=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);
  string error=null;
  try
  {
   foreach(var profile in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
   {
    var size=Activator.CreateInstance(assembly.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),profile[0],profile[1],"ZatodEconomyTest"},null);
    int index=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);gt.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,index);view.Repaint();
    await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==profile[0]&&Screen.height==profile[1],timeoutMs:8000,because:"economy UI resize");
    resultView.Open(record,session.LastCampaignReward,catalog,account,()=>{});await Task.Delay(1700);
    Check(resultView.TeamLabel.text=="Squad Level: 2"&&resultView.TeamExp.text.Contains("+6")&&resultView.TeamExp.text.Contains("5/25"),"Player result EXP/level");Check(resultView.GoldValue.text=="495","Gold reward placeholder");
    Check(resultView.HeroRow.GetComponentsInChildren<TextMeshProUGUI>().Count(x=>x.name=="Exp"&&x.text.Contains("+12"))==5,"Hero EXP split not shown");
    Check(resultView.TeamBar.Find("ProgressionFill").GetComponent<UnityEngine.UI.Image>().fillAmount>.19f,"Player bar not filled");
    var safe=resultView.GetComponent<RectTransform>();foreach(var rect in new[]{resultView.Panel,resultView.TeamBar,(RectTransform)resultView.Continue.transform})
    {var corners=new Vector3[4];rect.GetWorldCorners(corners);foreach(var c in corners)Check(safe.rect.Contains(safe.InverseTransformPoint(c)),"Reward control outside safe bounds");}
    if(profile[0]==1600&&profile[1]==900){ScreenCapture.CaptureScreenshot(Path.Combine(folder,"result.png"));await Task.Delay(150);}
    resultView.Hide();host.OpenHeroDetail(account.HeroDesk[0].HeroInstanceId);var detail=(ZatodHeroDetailView)typeof(ZatodPrototypeView).GetField("heroDetail",Flags).GetValue(host);await Task.Delay(100);
    Check(!detail.Exp.text.Contains("??"),"Hero curve not bound");Check(detail.InfoPanel.Find("ExpRail/ProgressionFill").GetComponent<UnityEngine.UI.Image>().fillAmount>0,"Hero Base EXP bar empty");Check(detail.CurrencyRow.Find("Gold/Value").GetComponent<TextMeshProUGUI>().text=="495","Gold balance not bound");Check(detail.CurrencyRow.Find("Stamina/Value").GetComponent<TextMeshProUGUI>().text.Contains("/62"),"Stamina cap not bound");
    if(profile[0]==1600&&profile[1]==900){ScreenCapture.CaptureScreenshot(Path.Combine(folder,"hero.png"));await Task.Delay(150);}
    detail.gameObject.SetActive(false);
   }
   resultView.Open(record,null,catalog,account,()=>{});Check(resultView.TeamExp.text=="Replay","Replay shows earned EXP");resultView.Hide();
  }
  catch(Exception e){error=e.ToString();}
  finally
  {
   resultView.Hide();selected.SetValue(view,oldIndex);int total=(int)gt.GetMethod("GetTotalCount").Invoke(group,null);for(int i=total-1;i>=initialCount;i--)gt.GetMethod("RemoveCustomSize").Invoke(group,new object[]{i});view.Repaint();
   typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(connection,null);
  }
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
