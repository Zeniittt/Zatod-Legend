ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashMemberRecordItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_rolefloor.png",
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
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.09999065, h = 56.3999906},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 110, 86),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "kill",
      z = 0,
      parent = "bg",
      text = "321",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334.75, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 110, 86),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "survival",
      z = 0,
      parent = "bg",
      text = "44",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(492.25, 29.75)
    }
  }
}
