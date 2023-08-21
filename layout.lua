local CurrentPage = PageNames[props["page_index"].Value]
local Colors = {
  Black     = {0,0,0}, --Black
  White     = {255,255,255}, --White
  Green     = {178,255,51}, --Shure Green
  Gray      = {105,105,105}, --Light Gray
  OffGray   = {124,124,124},
  BackGray = {102,102,102} --Normal Background Color
}
--local ContPins = "Unit Information~"
if CurrentPage == "Control" then
  table.insert(graphics,{
    Type = "GroupBox",
    Text = "Screen Animation",
    --Color = Colors.White,
    Fill = Colors.BackGray,
    CornerRadius = 8,
    StrokeColor = Colors.White,
    StrokeWidth = 1,
    Position = {6,6},
    Size = {700,600},
    FontSize = 12,
    HTextAlign = "Left"
  })
  table.insert(graphics,{
    Type = "Text",
    Text = "Screen Control",
    Position = {550,50},
    Color = Colors.White,
    Size = {120,20},
    FontSize = 12,
    HTextAlign = "Center"
  })
  table.insert(graphics,{
    Type = "GroupBox",
    Fill = Colors.White,
    CornerRadius = 8,
    StrokeColor = Colors.Black,
    StrokeWidth = 1,
    Position = {565,70},
    Size = {90,145},
    HTextAlign = "Center"
  })
  table.insert(graphics,{
    Type = "Text",
    Text = "Raising/Dropping Time(sec)",
    Position = {530,250},
    Color = Colors.White,
    Size = {160,20},
    FontSize = 12,
    HTextAlign = "Center"
  })
  table.insert(graphics,{
    Type = "Text",
    Text = "Mask",
    Position = {550,320},
    Color = Colors.White,
    Size = {120,20},
    FontSize = 12,
    HTextAlign = "Center"
  })

  -- System
  local prettyname
  for i= 1, 3 do
    if i == 1 then prettyname = "UP"
    elseif i == 2 then prettyname = "STOP"
    elseif i == 3 then prettyname = "DOWN"
    end
    layout["Btn "..i] = {
      PrettyName = prettyname,
      Style = "Button",
      FontSize = 12,
      Color = Colors.White,
      OffColor = Colors.OffGray,
      UnlinkOffColor = true,
      CornerRadius = 5,
      Margin = 5,
      StrokeWidth = 1,
      Position = {585,90+35*(i-1)},
      Size = {50,35}
    }
  end
  layout["Duration"] = {
    PrettyName = "Motion Time",
    Style = "Text",
    FontSize = 12,
    Color = Colors.White,
    OffColor = Colors.OffGray,
    UnlinkOffColor = true,
    CornerRadius = 5,
    Margin = 5,
    StrokeWidth = 1,
    Position = {585,270},
    Size = {50,35}
  }
  layout["Mask"] = {
    PrettyName = "Mask ON/OFF",
    Style = "Button",
    ButtonStyle = "Toggle",
    FontSize = 12,
    Position = {585,340},
    Size = {50,35},
    Color = Colors.White,
    OffColor = Colors.OffGray,
    UnlinkOffColor = true,
    CornerRadius = 5,
    Margin = 5,
    StrokeWidth = 1
  }
  layout["Image"] = {
    PrettyName = "Image",
    Style = "Button",
    Color = Colors.Gray,
    OffColor = Colors.Gray,
    UnlinkOffColor = true,
    StrokeWidth = 1,
    Margin = 2,
    Position = {35,50},
    Size = {500,500}
  }
end