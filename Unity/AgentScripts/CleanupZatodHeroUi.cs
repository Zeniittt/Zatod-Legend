using System;
using System.Reflection;
using UnityEditor;
using UnityEngine;
var assembly=typeof(Editor).Assembly;var flags=BindingFlags.Public|BindingFlags.NonPublic|BindingFlags.Instance;
var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var instance=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
var group=sizesType.GetMethod("GetGroup").Invoke(instance,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var type=group.GetType();
int removed=0;var getCount=type.GetMethod("GetTotalCount");var remove=type.GetMethod("RemoveCustomSize");
while((int)type.GetMethod("GetCustomCount").Invoke(group,null)>0)
{
    int count=(int)getCount.Invoke(group,null);var size=type.GetMethod("GetGameViewSize").Invoke(group,new object[]{count-1});
    string label=(string)size.GetType().GetProperty("baseText",flags).GetValue(size);if(!label.StartsWith("Zatod Review ",StringComparison.Ordinal))break;
    // Only ever address the verified last test preset. Different Editor versions
    // accept either a total index or a custom index; an invalid last index cannot
    // refer to an earlier user preset.
    try{remove.Invoke(group,new object[]{count-1});}catch(TargetInvocationException){}
    if((int)getCount.Invoke(group,null)==count){int custom=(int)type.GetMethod("GetCustomCount").Invoke(group,null);remove.Invoke(group,new object[]{custom-1});}
    if((int)getCount.Invoke(group,null)!=count-1)throw new Exception("Unexpected GameView preset cleanup result");removed++;
}
var windowType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(windowType);
if(SessionState.GetBool("ZatodHeroReviewSaved",false)){windowType.GetProperty("selectedSizeIndex",flags).SetValue(view,SessionState.GetInt("ZatodHeroReviewIndex",0));SessionState.SetBool("ZatodHeroReviewSaved",false);}
return new{RemovedTestPresets=removed,Scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene().path,SceneDirty=UnityEngine.SceneManagement.SceneManager.GetActiveScene().isDirty,Playing=EditorApplication.isPlaying};
