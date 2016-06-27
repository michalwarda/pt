function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

local state = {
  inputText = "",
  items = {
    {text = "Item 1", checked = true},
    {text = "Item 2", checked = false},
  }
};

local previousStates = {};

function getState()
  return state;
end

function setState(newState, action)
  diff = {state = state, action = action};
  table.insert(previousStates, diff);

  state = newState;
end

function dispatch(action)
  reduce(getState(), action);
end

function reduce(state, action)
  newState = deepcopy(state);
  actions = {
    updateInput = function() newState.inputText = action.text end,
    updateItemText = function() newState.items[action.index].text = action.text end,
    updateItemChecked = function() newState.items[action.index].checked = action.checked end,
    addItem = function() table.insert(newState.items, ({text = action.text, checked = false})) end,
    removeItem = function() table.remove(newState.items, action.index) end,
  }
  actions[action.type]();

  setState(newState, action);
  render(newState);
end

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

function Frame(props, template)
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

function Item(item, index)
  function OnCheck(self, btn, down)
    checked = self:GetChecked();
    dispatch({type = "updateItemChecked", index = index, checked = self:GetChecked()});
  end

  function OnChar(self, text)
    dispatch({type = "updateItemText", index = index, text = self:GetText()});
  end

  function OnDelete(self, btn, down)
    dispatch({type = "removeItem", index = index});
  end

  return Frame({
    Size = {280, 30},
    Point = {"TOPLEFT", 0, -((index - 1) * 30)},
    Children = {
      CheckBox({
          Size = {30, 30},
          Checked = item.checked,
          Scripts = {PostClick = OnCheck},
          Point = {"LEFT", 0, 0}}),
      Input({
          Size = {180, 30},
          Scripts = {OnChar = OnChar},
          Text = item.text,
          Point = {"LEFT", 40, 0}}),
      Button({
          Size = {30, 30},
          Text = "X",
          Scripts = {PostClick = OnDelete},
          Point = {"LEFT", 225, 0}})
    }
  })

end

function Items(items)
  local renderedItems = {};
  table.foreach(items, function(index, item)
    local renderedItem = table.insert(renderedItems, Item(item, index));
  end);
  return renderedItems;
end

local container = nil;

function render(state)
  if container ~= nil then container:Hide(); end

  function OnChar(self, text)
    dispatch({type = "updateInput", text = self:GetText()});
  end

  function OnEnterPressed(self)
    dispatch({type = "addItem", text = self:GetText()});
    dispatch({type = "updateInput", text = ""});
  end

  container = Frame({Root = true, Size = {300, 360}, Point = {"CENTER", 0, 0}, Children = {
    Text({Text = "WoW TodoMVC", UIParent = "TitleBg", Point = {"LEFT", 10, 5}}),
    Input({Size = {250, 30}, Text = state.inputText, Point = {"TOPLEFT", 15, -20}, UIParent = "Bg",
      Scripts = {OnChar = OnChar, OnEnterPressed = OnEnterPressed}}),
    Text({Text = "What needs to be done?", Point = {"TOPLEFT", 10, -10}, UIParent = "Bg"}),
    Frame({Size = {280, 500}, Point = {"TOP", 10, -50}, UIParent = "Bg", Children =
      Items(state.items)
    })
  }}, "BasicFrameTemplateWithInset")
end

render(getState());
