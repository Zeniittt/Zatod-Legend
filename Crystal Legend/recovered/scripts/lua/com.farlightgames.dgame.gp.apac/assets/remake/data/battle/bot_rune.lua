local ed = ed
local heroUseRuneList = {
  [33] = {
    Sun = {
      level = 7,
      attr = "CSDR",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "ARM",
      postfix = nil
    }
  },
  [66] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "ARMP",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "HIT",
      postfix = nil
    }
  },
  [77] = {
    Sun = {
      level = 7,
      attr = "MCSDR",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "ARMP",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "HIT",
      postfix = nil
    }
  },
  [16] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "HIT",
      postfix = nil
    }
  },
  [68] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "HIT",
      postfix = nil
    }
  },
  [1] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "STR",
      postfix = nil
    }
  },
  [7] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [10] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "CDR",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [11] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [12] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [13] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [24] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [28] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "CDR",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "STR",
      postfix = nil
    }
  },
  [35] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [47] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "HIT",
      postfix = nil
    }
  },
  [50] = {
    Sun = {
      level = 7,
      attr = "MIMU",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "STR",
      postfix = nil
    }
  },
  [51] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [58] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "CDR",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [61] = {
    Sun = {
      level = 7,
      attr = "CSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "CDR",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [65] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "STR",
      postfix = nil
    }
  },
  [67] = {
    Sun = {
      level = 7,
      attr = "HealRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "STR",
      postfix = nil
    }
  },
  [75] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "MCRIT",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [72] = {
    Sun = {
      level = 7,
      attr = "MCSD",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "MCRIT",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AP",
      postfix = nil
    }
  },
  [87] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  },
  [10015] = {
    Sun = {
      level = 7,
      attr = "MPRatio",
      postfix = nil
    },
    Moon = {
      level = 7,
      attr = "SKL",
      postfix = nil
    },
    Star = {
      level = 7,
      attr = "AGI",
      postfix = nil
    }
  }
}

local function getRuneItemId(type, condition)
  local level = condition.level
  local attr = condition.attr
  local ChinesePostfix = condition.postfix
  local runeTbl = ed.getDataTable("Rune")
  local itemId
  for item, runeInfo in pairs(runeTbl) do
    if type and runeInfo.Type ~= type then
    elseif level and runeInfo.Level ~= level then
    elseif attr and runeInfo.Attr ~= attr then
    elseif ChinesePostfix and runeInfo["Chinese Postfix"] ~= ChinesePostfix then
    else
      itemId = item
    end
  end
  if itemId then
    return itemId
  else
    print("Search Rune Fail:::" .. "level:" .. level .. "-attr:" .. attr .. "-postfix:" .. ChinesePostfix)
    debug.debug()
    return nil
  end
end

local function getRuneInfo(heroid, default)
  if type(heroid) == "string" then
    for id, info in pairs(ed.getDataTable("Unit")) do
      if info.Name == heroid then
        heroid = info.ID
        break
      end
    end
  end
  local heroSuperAwake = {
    _status = 1,
    _sun = 0,
    _moon = 0,
    _star = 0
  }
  if default then
    heroSuperAwake = default
  end
  local useRuneList = heroUseRuneList[heroid] or nil
  if useRuneList then
    local useSun = getRuneItemId("Sun", useRuneList.Sun)
    local useMoon = getRuneItemId("Moon", useRuneList.Moon)
    local useStar = getRuneItemId("Star", useRuneList.Star)
    if useSun then
      heroSuperAwake._sun = useSun
    end
    if useMoon then
      heroSuperAwake._moon = useMoon
    end
    if useStar then
      heroSuperAwake._star = useStar
    end
  end
  return heroSuperAwake
end

return getRuneInfo
