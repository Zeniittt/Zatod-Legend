ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashSetTeamTip = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 467.5, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/addteam_floor.png",
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
      fix_wh = {w = 25.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/addteam_addicon.png",
      name = "ImageView_140",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_141",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\230\183\187\229\138\160\233\152\159\228\188\141"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.75, 42.25)
    }
  }
}
