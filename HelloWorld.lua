local UIConfig = CreateFrame("FRAME", "HelloWorld", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(300, 360);
UIConfig:SetPoint("CENTER", UIParent, "CENTER");

UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
UIConfig.title:SetText("WoW TodoMVC");

local items = {
  {text = "Item 1", checked = true},
  {text = "Item 2", checked = false},
};

function renderInput()
  local label = UIConfig:CreateFontString(nil, "OVERLAY");
  label:SetFontObject("GameFontHighlight");
  label:SetPoint("TOPLEFT", UIConfig.Bg, "TOPLEFT", 10, -10);
  label:SetText("What needs to be done?");

  local input = CreateFrame("EditBox", "Input", UIConfig, "InputBoxTemplate");
  input:SetFontObject("GameFontHighlight")
  input:SetSize(250, 30);
  input:SetPoint("TOPLEFT", UIConfig.Bg, "TOPLEFT", 15, -20);
end

function renderItem(index, item)
  local frame = CreateFrame("Frame", "Item" .. index, UIConfig);
  frame:SetSize(250, 30);
  frame:SetPoint("TOP", UIConfig.Bg, "TOP", 0, -((index - 1) * 30) - 50);

  local button = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate");
  button:SetSize(30, 30);
  button:SetChecked(item.checked);
  button:SetPoint("CENTER", frame, "LEFT", 0, 0);

  local text1 = UIConfig:CreateFontString(nil, "OVERLAY");
  text1:SetFontObject("GameFontHighlight");
  text1:SetPoint("CENTER", frame, "LEFT", 40, 0);
  text1:SetText(item.text);
end

table.foreach(items, renderItem);
renderInput();

print("Eureka");
