module("ed.videoplayer", package.seeall)
network = {}
network.__index = network

function network.create()
  local object = {}
  setmetatable(object, network)
  return object
end

local test = false

function network:sendQueryVideo(videoid)
  local msg = ed.upmsg.video()
  msg._query_video = videoid
  self:send(msg)
end

function network:sendQueryBarrage(videoid)
  local msg = ed.upmsg.video()
  msg._query_barrage = videoid
  self:send(msg)
end

function network:sendBarrage(info)
  local msg = ed.upmsg.video()
  msg._send_barrage = ed.upmsg.send_barrage()
  msg._send_barrage._video_id = info.videoid
  msg._send_barrage._barrage = ed.common.barrage()
  msg._send_barrage._barrage._tick = info.tick
  msg._send_barrage._barrage._color = info.color
  msg._send_barrage._barrage._content = info.content
  self:send(msg)
end

function network:sendQueryVideoSummary(videoid)
  local msg = ed.upmsg.video()
  msg._query_video_summary = videoid
  self:send(msg)
end

function network:send(msg)
  if test then
    ed.printTable(msg)
  end
  ed.send(msg, "video")
end

function network:dispatch(msg)
  local event, data
  if msg._video_data then
    event = "video_data_reply"
    data = msg._video_data
  elseif msg._barrage_data then
    event = "barrage_data_reply"
    data = msg._barrage_data
  elseif msg._send_barrage then
    event = "send_barrage_reply"
    data = msg._send_barrage
  elseif msg._video_summary then
    local handler = ed.getNetReply("video_summary_reply")
    if handler then
      handler(msg._video_summary)
    end
  end
  if event then
    if test then
      print("videoplayer_network receive", event)
    end
    FireEvent(event, data)
  end
end

network = network.create()
