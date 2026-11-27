using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Editor
{
    public static class ZatodSkillUiAssets
    {
        public static int Prepare()
        {
            string reference=Environment.GetEnvironmentVariable("ZATOD_CRYSTAL_REFERENCE");
            string source=Path.Combine(string.IsNullOrWhiteSpace(reference)?"../Crystal Legend":reference,"recovered/assets/install_time_pack/remake")+Path.DirectorySeparatorChar;
            const string target="Assets/Zatod/Resources/Zatod/UI/Hero/Skills/";
            var catalog=HeroDataJson.LoadBundledCatalog();int count=0;
            void Copy(string input,string output)
            {
                string from=source+input,to=target+output+Path.GetExtension(input);
                if(!File.Exists(from))throw new FileNotFoundException("Missing native Skill UI art",from);
                Directory.CreateDirectory(Path.GetDirectoryName(to));
                if(!File.Exists(to) || !File.ReadAllBytes(from).SequenceEqual(File.ReadAllBytes(to)))File.Copy(from,to,true);
                AssetDatabase.ImportAsset(to,ImportAssetOptions.ForceSynchronousImport);
                var importer=(TextureImporter)AssetImporter.GetAtPath(to);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;
                importer.mipmapEnabled=false;importer.alphaIsTransparency=true;importer.maxTextureSize=2048;
                importer.textureCompression=TextureImporterCompression.Uncompressed;
                importer.SaveAndReimport();count++;
            }
            foreach(var skill in catalog.Data.Heroes.SelectMany(h=>h.SkillSlots).Select(s=>catalog.Skill(s.SkillId)))Copy(skill.IconResource,"Icons/"+skill.Id);
            foreach(var name in new[]{"skill_icon_bg_1","skill_icon_bg_2","skill_name_bg","skill_button_bg","skill_max"})Copy("UI/alpha/1080P/skill/new/"+name+".png",name);
            foreach(var name in new[]{"skill_lock","skill_frame_choose","skill_rank_1","skill_rank_2"})Copy("UI/alpha/1080P/skill/"+name+".png",name);
            // Presentation metadata and source art are copied by Import-ZatodSkillUi.py.
            foreach(string file in Directory.GetFiles(target,"*",SearchOption.AllDirectories).Where(p=>p.EndsWith(".png") || p.EndsWith(".jpg")))
            {
                AssetDatabase.ImportAsset(file,ImportAssetOptions.ForceSynchronousImport);
                var importer=(TextureImporter)AssetImporter.GetAtPath(file);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;
                importer.mipmapEnabled=false;importer.alphaIsTransparency=true;importer.textureCompression=TextureImporterCompression.Uncompressed;
                importer.SaveAndReimport();
            }
            AssetDatabase.SaveAssets();return count;
        }
    }
}
