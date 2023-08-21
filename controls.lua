table.insert(ctrls, {
  Name = "Image",
  ControlType = "Button",
  ButtonType = "Toggle",
  PinStyle = "Both",
  Count = 1,
  UserPin = true
})
table.insert(ctrls, {
  Name = "Duration",
  ControlType = "Knob",
  ControlUnit = "Float",
  Min = 1,
  Max = 30,
  DefaultValue = 6,
  PinStyle = "Both",
  Count = 1,
  UserPin = true
})
table.insert(ctrls, {
  Name = "Mask",
  ControlType = "Button",
  ButtonType = "Toggle",
  PinStyle = "Both",
  Count = 1,
  Value = true,
  UserPin = true
})
table.insert(ctrls, {
  Name = "Btn",
  ControlType = "Button",
  ButtonType = "Trigger",
  PinStyle = "Both",
  Count = 3,
  UserPin = true
})