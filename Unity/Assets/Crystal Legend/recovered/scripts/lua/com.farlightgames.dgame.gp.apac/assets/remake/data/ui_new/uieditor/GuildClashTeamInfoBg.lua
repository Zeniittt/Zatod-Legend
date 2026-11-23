ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashTeamInfoBg = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 471, h = 171},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_floor.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_icon.png",
      name = "icon_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182.5, 150)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(229, 198, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_guild",
      z = 0,
      parent = "icon_guild",
      text = T("\229\133\172\228\188\154\233\152\159\228\188\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31, 10)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_num",
      z = 0,
      parent = "icon_guild",
      text = T("6\233\152\159"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.5, 10)
    }
  }
}
