using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class SetupCampaign
{
    public static object Run()
    {
        if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before Campaign setup.");
        var scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
        if(scene.path!="Assets/Zatod/Scenes/ArenaPrototype.unity")throw new InvalidOperationException("Open ArenaPrototype.");
        var arena=UnityEngine.Object.FindAnyObjectByType<ArenaView>();if(arena==null)throw new InvalidOperationException("Missing Arena bootstrap");
        Directory.CreateDirectory("../Artifacts/CampaignBefore/20261118-105757");
        EditorSceneManager.SaveScene(scene,"../Artifacts/CampaignBefore/20261118-105757/SceneBeforeCampaign.unity",true);
        var font=FormationSetup.EnsureFont();
        string labels=File.ReadAllText(CampaignDataJson.AssetPath)+"KẾT NỐI CHƯƠNG ẢI HOÀN THÀNH ĐỘI HÌNH ĐỊCH CHỌN ĐỘI HÌNH Chọn từ 1 đến 5 Hero để vào trận. Hoàn thành ải trước để mở khóa."
            +"CHIẾN THẮNG CHƯA VƯỢT QUA Điều chỉnh đội hình và thử lại. BẢN ĐỒ XEM LẠI ẢI TIẾP THEO ĐANG CHUẨN BỊ TRẬN QUAY LẠI BẢN ĐỒ Không thể bắt đầu trận. ĐÃ KẾT NỐI Chưa kết nối nhấn để thử lại ·";
        if(!font.TryAddCharacters(labels,out string missing))throw new InvalidOperationException("Font missing glyphs: "+missing);
        EditorUtility.SetDirty(font);AssetDatabase.SaveAssets();
        if(arena.GetComponent<CampaignView>()==null)arena.gameObject.AddComponent<CampaignView>();
        EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);AssetDatabase.Refresh();
        var catalog=CampaignDataJson.Load(HeroDataJson.LoadBundledCatalog());
        return new{chapter=catalog.Data.Chapters[0].Name,stages=catalog.Data.Chapters[0].Stages.Count,heroes=catalog.Data.StarterHeroIds.Count};
    }
}
