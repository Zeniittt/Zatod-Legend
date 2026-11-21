using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Zatod.Presentation;
public static class SetupZatodBattleResult
{
    public static object Run()
    {
        if(Application.isPlaying)throw new Exception("Stop Play first.");
        const string root="Assets/Zatod/Resources/Zatod/UI/BattleResult";
        int count=0;
        foreach(string path in Directory.GetFiles(root,"*.png",SearchOption.AllDirectories))
        {
            AssetDatabase.ImportAsset(path,ImportAssetOptions.ForceSynchronousImport);var t=(TextureImporter)AssetImporter.GetAtPath(path);
            t.textureType=TextureImporterType.Sprite;t.spriteImportMode=SpriteImportMode.Single;t.spritePixelsPerUnit=100;t.mipmapEnabled=false;t.alphaIsTransparency=true;t.npotScale=TextureImporterNPOTScale.None;t.filterMode=FilterMode.Bilinear;t.wrapMode=TextureWrapMode.Clamp;t.textureCompression=TextureImporterCompression.Uncompressed;t.maxTextureSize=4096;t.SaveAndReimport();count++;
            if(path.Replace('\\','/').EndsWith("/common/mail_bj9_1.png")){t.spriteBorder=new Vector4(10,10,10,10);t.SaveAndReimport();}
        }
        string audioFolder="Assets/Zatod/Resources/Zatod/Audio";Directory.CreateDirectory(audioFolder);
        foreach(string name in new[]{"battle_loot","battle_win","battledown_star_one"})
        {
            string source=Path.GetFullPath("../Crystal Legend/recovered/assets/install_time_pack/remake/sound_menu/"+name+".mp3"),target=audioFolder+"/"+name+".mp3";
            if(!File.Exists(target))File.Copy(source,target);AssetDatabase.ImportAsset(target,ImportAssetOptions.ForceSynchronousImport);
        }
        var font=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>()?.Font;if(font==null)throw new Exception("Open ZatodPrototype to use its configured UI font.");
        var preview=EditorSceneManager.NewPreviewScene();GameObject temporary=null;
        try
        {
            temporary=new GameObject("ResultAuthoring",typeof(RectTransform));UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(temporary,preview);
            var view=ZatodBattleResultView.Create(temporary.transform,font);PrefabUtility.SaveAsPrefabAsset(view.gameObject,root+"/ZatodBattleResultView.prefab");
        }
        finally{if(temporary!=null)UnityEngine.Object.DestroyImmediate(temporary);EditorSceneManager.ClosePreviewScene(preview);}
        AssetDatabase.SaveAssets();return new{NativeImages=count,Prefab=root+"/ZatodBattleResultView.prefab"};
    }
}
