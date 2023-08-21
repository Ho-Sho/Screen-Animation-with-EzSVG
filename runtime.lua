--Debug Function
---------------------------------------------------------
function DebugFormat(string) -- Format strings containing non-printable characters so we can see what they are
  local visual = ""
  for i=1,#string do
    local byte = string:sub(i,i)
    if string.byte(byte) >= 32 and string.byte(byte) <= 126 then
      visual = visual..byte
    else
      visual = visual..string.format("[%02xh]",string.byte(byte))
    end
  end
  return visual
end

DebugTx = false
DebugRx = false
DebugFunction = false
DebugPrint = Properties["Debug Print"].Value

-- A function to determine common print statement scenarios for troubleshooting
function SetupDebugPrint()
  if DebugPrint=="Tx/Rx" then
    DebugTx,DebugRx=true,true
  elseif DebugPrint=="Tx" then
    DebugTx=true
  elseif DebugPrint=="Rx" then
    DebugRx=true
  elseif DebugPrint=="Function Calls" then
    DebugFunction=true
  elseif DebugPrint=="All" then
    DebugTx,DebugRx,DebugFunction=true,true,true
  end
end

SetupDebugPrint()

---------------------------------------------------------
local rapidjson = require 'rapidjson'
local EzSVG = require 'EzSVG'

local docSize = 1000
local center = docSize / 2
local d = docSize --grid
local stop_pos = d/2 - d/8 -- 3/8 of Campus

local fillColor = "white"
local strokeColor = "black"
local strokeWidth = 1
local fillOpacity = 1
local btn = Controls["Btn"]

local sec = 1/30 -- Change Point Frame Rate
local duration = 5 -- motion time
local step = stop_pos / (1/sec * duration)--10 d/100
local amount = 0 -- 1 dot
local maskfillColor = "black"
local maskSwitch = Controls["Mask"]

--Functions
function DrawSVG(svgData)
  Controls.Image.Legend = rapidjson.encode({
  DrawChrome = false,
  IconData = Crypto.Base64Encode(svgData),
  })
end

function DrawScreen(doc, amount)
  local motor = EzSVG.Group()
  local fabric = EzSVG.Group()
  local batom = EzSVG.Group()

  local L = d/2 + (d/8*2) -- half + half/2
  local H = d/32
  local x = center - d/4 - d/8
  local y = center - d/4 - d/16 + d/128

  local s_motor = EzSVG.Rect(x, y, L, H, d/200, d/200)-- create a motor
    :setStyle("fill", fillColor)
    :setStyle("fill-opacity", fillOpacity)
    :setStyle("stroke", strokeColor)
    :setStyle("stroke-width", strokeWidth)
  motor:add(s_motor) -- add motor to group

  local mask = d/80 --mask width

  local f_L = d/2 + (d/16*2) + (2 * mask)
  local f_H = amount
  local f_x = center - d/4 - d/16 - mask
  local f_y = center - d/4 + mask - d/32 - (amount == d * 3/8 and 0 or mask )
  --print("f_y : "..f_y)
  local s_fabric = EzSVG.Rect(f_x, f_y, f_L, f_H)-- create a fabric
    :setStyle("fill", fillColor)--fillColor
    :setStyle("fill-opacity", fillOpacity)
    :setStyle("stroke", maskfillColor)
    :setStyle("stroke-width", mask)
  fabric:add(s_fabric) -- add fabric to group

  local b_L = L - d/32*2
  local b_H = amount
  local b_x = center - d/4 - d/8 + d/32
  local b_y = f_y + amount  - (amount == 0 and mask or 0)
  --print("b_y : "..b_y)
  local s_batom = EzSVG.Rect(b_x, b_y, b_L, d/64)-- create a batom
    :setStyle("fill", maskfillColor)
    :setStyle("fill-opacity", fillOpacity)
    :setStyle("stroke", strokeColor)
    :setStyle("stroke-width", strokeWidth)
  batom:add(s_batom) -- add batom to group
  local offset = 50
  motor :translate(0, offset) --x, y offset
  fabric:translate(0, offset)
  batom :translate(0, offset)

  doc:add(batom)
  doc:add(fabric)
  doc:add(motor)

end

--DrawCampus
function DrawCampus()
  local doc = EzSVG.Document(docSize, docSize)
  DrawScreen(doc, amount)
  local svgData = doc:toString()
  DrawSVG(svgData)
end

--Timers
upTimer = Timer.New()
downTimer = Timer.New()

upTimer.EventHandler = function()
  amount = (amount - step < 0 ) and 0 or amount - step
  DrawCampus()
  --print("UpTime amount:"..amount)
  if amount <= 0 then
    upTimer:Stop()
    print("UpTimerStop")
    amount = 0
  end
end

downTimer.EventHandler = function()
  amount = (amount + step > stop_pos) and stop_pos or amount + step
  DrawCampus()
  --print("Down Time amount:"..amount)
  if amount >= stop_pos then
    downTimer:Stop()
    print("DownTimerStop")
    amount = stop_pos--Stop Position 3/8 of Campas
  end
end

--EventHandlers
btn[1].EventHandler = function()
  print("UpTimerStart")
  downTimer:Stop()
  upTimer:Start(sec)
end

btn[3].EventHandler = function()
  print("DownTimerStart")
  upTimer:Stop()
  downTimer:Start(sec)
end

btn[2].EventHandler = function()
  print("TimerStop")
  upTimer:Stop()
  downTimer:Stop()
end

maskSwitch.EventHandler = function()
  maskfillColor = maskSwitch.Boolean == true and "black" or "white"
  maskSwitch.Color = maskSwitch.Boolean == true and "Black" or "White"
  maskSwitch.Legend = maskSwitch.Boolean == true and "Black" or "White"
  DrawCampus()
end

Controls.Duration.EventHandler = function()
  duration = math.floor(Controls.Duration.Value * 10) / 10 --Rounded down to one decimal place
  Controls.Duration.Value = duration
  step = stop_pos / (1/sec * duration)
  DrawCampus()
end

--initialize
btn[1].Legend = "\u{25B2}"--"▲"
btn[2].Legend = "\u{25A0}"--"■"
btn[3].Legend = "\u{25BC}"--"▼"
maskSwitch.Color = "Black"
maskSwitch.Legend ="Black"
maskSwitch.Boolean=true

DrawCampus()