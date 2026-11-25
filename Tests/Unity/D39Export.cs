using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using Zatod.Editor;
public static class D39Export
{
    public static string Run(string root)
    {
        if(EditorApplication.isPlaying||!Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))throw new Exception("Stop Play Mode in the isolated build workspace first");
        var queued=EditorApplication.delayCall;
        if(queued!=null)foreach(var callback in queued.GetInvocationList())if(callback.Method.DeclaringType?.FullName.StartsWith("D39Export",StringComparison.Ordinal)==true)EditorApplication.delayCall-=(EditorApplication.CallbackFunction)callback;
        Directory.CreateDirectory(root);File.WriteAllText(Path.Combine(root,"export-status.json"),"{\"State\":\"RUNNING\"}");
        try
        {
            ZatodIosBuild.ExportTo(Path.Combine(root,"Xcode"));
            File.Copy(Path.Combine(ZatodIosBuild.Checks,"ios-export.json"),Path.Combine(root,"unity-export.json"));
            File.WriteAllText(Path.Combine(root,"export-status.json"),"{\"State\":\"PASS\"}");
        }
        catch(Exception e){File.WriteAllText(Path.Combine(root,"export-status.json"),JsonUtility.ToJson(new Failure{State="FAIL",Error=e.ToString()},true));throw;}
        return root;
    }
    [Serializable] sealed class Failure{public string State,Error;}
}
