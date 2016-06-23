local UIConfig = CreateFrame("FRAME", "HelloWorld", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(300, 360);
UIConfig:SetPoint("CENTER", UIParent, "CENTER");

UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
UIConfig.title:SetText("MUI Buff Options");

local dom = table.concat({"item1", "item2", "item3"}, "<br/>");

UIConfig.html1 = CreateFrame('SimpleHTML', nil, UIConfig);
UIConfig.html1:SetText('<html><body><p>' .. dom .. '</p></body></html>');
UIConfig.html1:SetSize(100, 100);
UIConfig.html1:SetPoint("TOPLEFT", UIConfig.Bg, 10, -10);
UIConfig.html1:SetFont('Fonts\\FRIZQT__.TTF', 11);