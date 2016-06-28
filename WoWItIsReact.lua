function Component(name, props, template)
  -- CREATE FRAME
  local component = CreateFrame(name, nil, nil, template);
  component.UIParent = props.UIParent;
  component.Point = props.Point;

  -- SET PROPS
  for property, value in pairs(props) do
    if property ~= "Children" and property ~= "Scripts" and property ~= "Parent" and property ~= "UIParent" and property ~= "Point" and property ~= "Root" then
      if type(value) == "table" then
        component['Set' .. property](component, unpack(value));
      else
        component['Set' .. property](component, value);
      end
    end
  end

  -- SET SCRIPTS
  if props.Scripts then
    for on, fn in pairs(props.Scripts) do
      component:SetScript(on, fn);
    end
  end

  -- SET PARENT
  if props.Root == true then
    component:SetParent(UIParent);
    component:SetPoint(unpack(props.Point));
  end

  -- SET CHILDREN
  if props.Children then
    table.foreach(props.Children, function(_, child)
      local location, x, y = unpack(child.Point);
      if child.UIParent then
        child:SetPoint(location, component[child.UIParent], location, x, y);
      else
        child:SetPoint(location, component, location, x, y);
      end

      child:SetParent(component);
    end);
  end

  return component;
end

-- COMPONENTS

function Div(props, template)
  return Component("Frame", props, template);
end

function Input(props)
  local input = Component("EditBox", props, "InputBoxTemplate");
  input:SetFontObject("GameFontHighlight");

  return input;
end

function Text(props)
  local text = Component("SimpleHTML", props, nil);
  text:SetFont('Fonts\\FRIZQT__.TTF', 11);
  text:SetSize(1, 1);

  return text;
end

function CheckBox(props)
  return Component("CheckButton", props, "UICheckButtonTemplate");
end

function Button(props)
  return Component("Button", props, "GameMenuButtonTemplate");
end

container = nil;

function renderView(state)
  if container ~= nil then container:Hide(); end
  container = render(getState());
end
