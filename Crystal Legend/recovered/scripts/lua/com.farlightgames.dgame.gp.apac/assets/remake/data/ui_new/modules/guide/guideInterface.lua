local guideInterface = {}

function guideInterface:getGuideNode(nodeKey)
  return self.ui[nodeKey] or self[nodeKey]
end

function guideInterface:getGuideRelatedNode(nodeKey)
  return nil
end

function guideInterface:getGuideClipRect(nodeKey)
  return nil
end

ed.guide.interface = {interface = guideInterface}
